module ApplicationHelper
  def active_link_to name, path, opts={}
    opts[:class] = opts[:class].to_s + ' active' if request.path == path
    link_to name, path, opts
  end

  def request_type_icon request_type
    request_types = {
        'icon-request-leave'  => 'rural18_32x28.png',
        'icon-request-travel' => 'air6_32x28.png'
    }
    image_tag(request_types[request_type], class: 'icon-request')
  end

  def tz_convert(timeobj,tz,format='%Y-%m-%d %I:%M%p')
    return TZInfo::Timezone.get(tz).utc_to_local(timeobj).strftime(format)
  end
end
