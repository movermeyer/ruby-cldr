# encoding: UTF-8

module Cldr
  module Export
    module Data
      class Rbnf < Base

        def initialize(*args)
          super
          update(:rbnf => { :grouping => rule_groups })
        end

        def rule_groups
          if File.exist?(path)
            select("rbnf/rulesetGrouping").map do |grouping_node|
              {
                :type => grouping_node.attribute("type").value,
                :ruleset => (grouping_node / "ruleset").map do |ruleset_node|
                  rule_set(ruleset_node)
                end
              }
            end
          else
            {}
          end
        end

        def rule_set(ruleset_node)
          attrs = {
            :type => ruleset_node.attribute("type").value,
            :rules => (ruleset_node / "rbnfrule").map do |rule_node|
              radix = if radix_attr = rule_node.attribute("radix")
                cast_value(radix_attr.value)
              else
                nil
              end

              attrs = {
                :value => cast_value(rule_node.attribute("value").value),
                :rule => fix_rule(rule_node.text)
              }

              attrs[:radix] = radix if radix
              attrs
            end
          }

          access = ruleset_node.attribute("access")
          attrs[:access] = access.value if access
          attrs
        end

        def cast_value(val)
          if val =~ /\A[\d]+\z/
            val.to_i
          else
            val
          end
        end

        def fix_rule(rule)
          rule.gsub(/\A'/, '').gsub("←", '<').gsub("→", '>')
        end

        def path
          @path ||= "#{Cldr::Export::Data.dir}/rbnf/#{Cldr::Export.from_i18n(locale)}.xml"
        end

      end
    end
  end
end
