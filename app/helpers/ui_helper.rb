# app/helpers/ui_helper.rb
module UiHelper
  # Button Helper with types similar to MUI buttons
  def button(text, type: :primary, options: {})
    default_classes = case type
    when :primary
                        "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-sm"
    when :secondary
                        "bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded-sm"
    when :success
                        "bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-sm"
    when :danger
                        "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-sm"
    else
                        "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-sm"
    end

    classes = [ default_classes, options.delete(:class) ].compact.join(" ")
    content_tag(:button, text, options.merge(class: classes))
  end

  # Input Helper
  def input(name, value = nil, options = {})
    default_classes = "shadow-sm appearance-none border rounded-sm w-full py-2 px-3 text-gray-700 leading-tight focus:outline-hidden focus:shadow-outline"
    classes = [ default_classes, options.delete(:class) ].compact.join(" ")
    text_field_tag(name, value, options.merge(class: classes))
  end

  # Container Helper
  def container(options = {}, &block)
    default_classes = "container mx-auto px-4"
    classes = [ default_classes, options.delete(:class) ].compact.join(" ")
    content_tag(:div, options.merge(class: classes), &block)
  end

  # Navbar Helper
  def navbar(options = {}, &block)
    default_classes = "bg-gray-800 p-4 text-white"
    classes = [ default_classes, options.delete(:class) ].compact.join(" ")
    content_tag(:nav, options.merge(class: classes), &block)
  end

  # Enhanced Card Helper with optional header, image, title, content, footer, and block content
  def card(header: nil, image: nil, title: nil, content: nil, footer: nil, options: {}, &block)
    container_classes = "bg-white shadow-sm rounded-sm overflow-hidden"
    container_classes = [ container_classes, options.delete(:class) ].compact.join(" ")

    content_tag(:div, options.merge(class: container_classes)) do
      # Header Section
      concat(content_tag(:div, header, class: "px-4 py-2 bg-gray-100")) if header.present?

      # Image Section
      if image.present?
        concat(image_tag(image, class: "w-full", alt: title || "Card image"))
      end

      # Body Section
      concat(content_tag(:div, class: "p-4") do
        inner = "".html_safe
        inner << content_tag(:h2, title, class: "text-xl font-bold mb-2") if title.present?
        inner << content_tag(:p, content, class: "text-gray-700") if content.present?
        inner << capture(&block) if block_given?
        inner
      end)

      # Footer Section
      concat(content_tag(:div, footer, class: "px-4 py-2 bg-gray-100")) if footer.present?
    end
  end

  # === Grid Components ===
  #
  # Grid Container
  # Inspired by MUI Grid container, this helper creates a grid container with a customizable
  # number of columns and gap spacing.
  #
  # Parameters:
  # - columns: Number of columns (default 12)
  # - spacing: Numeric value for gap (Tailwind class "gap-{spacing}")
  #
  # Example:
  #   <%= grid_container(columns: 12, spacing: 4) do %>
  #     <%= grid_item(span: 6) { "Item 1" } %>
  #     <%= grid_item(span: 6) { "Item 2" } %>
  #   <% end %>
  def grid_container(columns: 12, spacing: 4, options: {}, &block)
    grid_classes = [ "grid", "grid-cols-#{columns}", "gap-#{spacing}", options.delete(:class) ].compact.join(" ")
    content_tag(:div, options.merge(class: grid_classes), &block)
  end

  # Grid Item
  # Wraps content to span a specific number of columns.
  #
  # Parameter:
  # - span: Number of columns to span (default 12)
  #
  # Example:
  #   <%= grid_item(span: 6) { "Half width item" } %>
  def grid_item(span: 12, options: {}, &block)
    item_classes = [ "col-span-#{span}", options.delete(:class) ].compact.join(" ")
    content_tag(:div, options.merge(class: item_classes), &block)
  end

  # Stack Component (Updated)
  #
  # - direction: :vertical (default) or :horizontal
  # - spacing: Numeric value for spacing (uses Tailwind's space-y-{n} or space-x-{n} classes)
  # - reverse: If true, reverses the order of items (adds flex-col-reverse or flex-row-reverse)
  #
  # Example:
  #   <%= stack(direction: :vertical, spacing: 4, reverse: true) do %>
  #     <%= content_tag(:div, "Item 1", class: "bg-gray-200 p-4") %>
  #     <%= content_tag(:div, "Item 2", class: "bg-gray-200 p-4") %>
  #   <% end %>
  def stack(direction: :vertical, spacing: 4, reverse: false, options: {}, &block)
    base_class = case direction
    when :horizontal
                   reverse ? "flex flex-row-reverse" : "flex flex-row"
    else
                   reverse ? "flex flex-col-reverse" : "flex flex-col"
    end
    spacing_class = "gap-%s" % spacing
    stack_classes = [ base_class, spacing_class, options.delete(:class) ].compact.join(" ")

    content_tag(:div, options.merge(class: stack_classes), &block)
  end
end
