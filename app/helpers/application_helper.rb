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

  def hf_hour_options
    [
      '12am',
      '1am',
      '2am',
      '3am',
      '4am',
      '5am',
      '6am',
      '7am',
      '8am',
      '9am',
      '10am',
      '11am',
      '12pm',
      '1pm',
      '2pm',
      '3pm',
      '4pm',
      '5pm',
      '6pm',
      '7pm',
      '8pm',
      '9pm',
      '10pm',
      '11pm'
    ]
  end

  def hf_boolean_to_words value
    value.present? ? "Yes" : "No"
  end
end
