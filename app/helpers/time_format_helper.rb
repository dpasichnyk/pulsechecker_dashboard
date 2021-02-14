module TimeFormatHelper

  def milliseconds_to_human_readable(milliseconds)
    return '' unless milliseconds
    data = { hour: nil, minute: nil, second: nil }

    data[:hour], milliseconds = milliseconds.divmod(1000 * 60 * 60)
    data[:minute], milliseconds = milliseconds.divmod(1000 * 60)
    data[:second], _milliseconds = milliseconds.divmod(1000)

    data.map {|entry| return pluralize(entry[1], entry[0].to_s) if entry[1] > 0 }.first
  end
end
