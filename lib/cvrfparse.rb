require "cvrfparse/version"
require 'nokogiri'
require 'open-uri'

module CVRFPARSE

  CVRF_SCHEMA = 'http://www.icasi.org/CVRF/schema/cvrf/1.1/cvrf.xsd'
  CVRF_NAMESPACES = {
      cvrf: 'http://www.icasi.org/CVRF/schema/cvrf/1.1',
      prod: 'http://www.icasi.org/CVRF/schema/prod/1.1',
      vuln: 'http://www.icasi.org/CVRF/schema/vuln/1.1'
  }

  class CVRF_parser
    def validate(document_path, schema_path=CVRF_SCHEMA)
      schema = Nokogiri::XML::Schema(open(schema_path))
      document = Nokogiri::XML(open(document_path))

      schema.validate(document)
    end

    def parse(document_path, parsables, namespace)
      document = Nokogiri::XML(open(document_path))

      items = []

      parsables.each do |p|
        nodes = document.xpath('//x:' + p, 'x' => CVRF_NAMESPACES[namespace] )
        nodes.each do |n|
          node = {namespace: n.namespace.href, name: n.name, text: n.children.text}
          items << node
        end
      end

      return items
    end
  end

end
