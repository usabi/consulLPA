require_dependency Rails.root.join('lib', 'census_api').to_s

class CensusApi
  attr_accessor :client
  attr_accessor :uri

  def initialize
    @uri = uri
    return unless @uri
    @client = Net::HTTP.new(@uri.host, @uri.port)
    @client.use_ssl = @uri.scheme == 'https'
  end

  def uri
    return unless end_point_available?
    URI.parse(Rails.application.secrets.census_api_end_point)
  end

  def call(document_type, document_number, date_of_birth)
    response = nil
    get_document_number_variants(document_type, document_number).each do |variant|
      response = Response.new(get_response_body(document_type, variant, date_of_birth))
      return response if response.valid?
    end
    response
  end

  class Response
    require 'net/http'

    def initialize(body)
      @body = Nokogiri::XML(body)
    end

    def valid?
      @body.xpath('//estado').text == 'OK'
    end

    def postal_code
      @body.xpath('//cp').text
    end

    def district_code
      @body.xpath('//distrito').text
    end

    def errors
      case (@body.xpath('//estado').text)
        when 'OK FECHA NO COINCIDE'
          :birth_date_no_correct
        when 'NO OK ERROR EN CENSO'
          :error_verifying_census
        when 'NO OK DEMASIADAS CONEXIONES'
          :error_to_many_connections

      end
    end

  end

  private

  def get_response_body(document_type, document_number, date_of_birth)
    return stubbed_response(document_type, document_number, date_of_birth) unless end_point_available?

    date_of_birth = I18n.l(date_of_birth) if date_of_birth.is_a?(Date)
    encoded_uri = URI.encode_www_form({ id: document_number, date: date_of_birth })
    request_uri = @uri.request_uri + '?' + encoded_uri
    response = nil
    request = Net::HTTP::Get.new(request_uri)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    response = @client.request(request).body
  end

  def stubbed_response(document_type, document_number, date_of_birth)
    return stubbed_to_many_connections_response if date_of_birth == '01/01/1900'.to_date

    if document_number == '12345678Z'
      if date_of_birth == '01/01/1970'.to_date
        stubbed_valid_response
      else
        stubbed_invalid_birth_date_response
      end
    else
      stubbed_invalid_response
    end
  end

  def stubbed_valid_response
    "<respuesta>\n<estado>OK</estado>\n<cp>35000</cp>\n<distrito>1</distrito>\n</respuesta>"
  end

  def stubbed_invalid_birth_date_response
    "<respuesta>\n<estado>OK FECHA NO COINCIDE</estado>\n<cp>35000</cp>\n<distrito>1</distrito>\n</respuesta>"
  end
  def stubbed_to_many_connections_response
    "<respuesta>\n<estado>NO OK DEMASIADAS CONEXIONES</estado></respuesta>"
  end

  def stubbed_invalid_response
    "<respuesta>\n<estado>NO OK ERROR EN CENSO</estado></respuesta>"
  end

end
