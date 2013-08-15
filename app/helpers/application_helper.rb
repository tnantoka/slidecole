module ApplicationHelper

  def title_tag(page_title)
    c = controller.controller_name
    a = controller.action_name
    page_title += ' - ' if page_title.present?
    if c == 'welcome' && a == 'index'
      "#{t(:brand)}: #{t(:lead)}"
    else
      localized_title = t("title.#{c}.#{a}")
      localized_title += ' - ' if localized_title.present?
      "#{page_title}#{localized_title}#{t(:brand)}"
    end
  end

  def time_ago(date)
    return "<span title=\"#{l(date)}\">#{time_ago_in_words(date)}#{t('ago')}</span>".html_safe
  end

  # markdonw
  def render_md(content)
    content = content.to_s
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      link_attributes: { target: '_blank' }
    )
    extensions = {
      fenced_code_blocks: true,
      autolink: true,
    }
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(content).html_safe
  end

  # for bootstrap
  def col(n)
    "col-sm-#{n}"
  end

  def offset(n)
    "col-sm-offset-#{n}"
  end

end
