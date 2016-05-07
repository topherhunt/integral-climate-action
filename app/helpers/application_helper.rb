module ApplicationHelper

  def bootstrap_flash_class(key)
    case key.to_sym
    when :notice
      'info'
    when :alert
      'warning'
    else
      raise "Unrecognized flash key '#{key.to_s}'!"
    end
  end

  def show_errors_for (object)
    render 'shared/errors', object: object if object.errors.any?
  end

  def glyph (name)
    content_tag :span, '', class: "glyphicon glyphicon-#{name.to_s}"
  end

  def date(input, opt={})
    return unless input.present?

    output = ""
    output += input.strftime("%b %e")
    output += " #{input.year}" if input.year != Time.now.year or opt[:year]
    output += input.strftime(", %l:%M %P") if opt[:time]
    output
  end
end
