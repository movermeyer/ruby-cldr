# frozen_string_literal: true

module Cldr
  module Format
    class Decimal
      class Integer < Base
        attr_reader :format, :separator, :groups

        def initialize(format, symbols = {})
          super()

          format     = format.split(".")[0]
          @format    = prepare_format(format, symbols)
          @groups    = parse_groups(format)
          @separator = symbols[:group] || ","
        end

        def apply(number, options = {})
          format_groups(interpolate(format, number.to_i))
        end

        def format_groups(string)
          return string if groups.empty?
          tokens = []
          tokens << chop_group(string, groups.first)
          tokens << chop_group(string, groups.last) while string.length > groups.last
          tokens << string
          tokens.compact.reverse.join(separator)
        end

        def parse_groups(format)
          return [] unless (index = format.rindex(","))
          rest   = format[0, index]
          widths = [format.length - index - 1]
          widths << rest.length - rest.rindex(",") - 1 if rest.rindex(",")
          widths.compact.uniq
        end

        def chop_group(string, size)
          string.slice!(-size, size) if string.length > size
        end

        def prepare_format(format, symbols)
          signs = symbols.values_at(:plus_sign, :minus_sign)
          format.tr(",", "").tr("+-", signs.join)
        end
      end
    end
  end
end
