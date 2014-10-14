module ApplicationHelper
    def sort_col (col, title= nil)
    title ||= col.titleize
    link_to title, {:field_name => col}
    end
    def sorted?(title)
      title == sorted_col ? {:class => "hilite"} : {:class => nil}
    end
end
