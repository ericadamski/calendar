class Calendar
  constructor: ->
    @month2string = (month) ->
      months = {
        0: "January",
        1: "Feburary",
        2: "March",
        3: "April",
        4: "May",
        5: "June",
        6: "July",
        7: "August",
        8: "September",
        9: "October",
        10: "November",
        11: "December"
      }
      months[month]

    @current_date = new Date()

    @this_month = @current_month = @current_date.getMonth()
    @today                      = @current_date.getDate()
    @this_year = @current_year   = @current_date.getFullYear()
    @this_day                   = @current_date.getDay()

    @populateCalendar @this_month, @this_year

  getCalendarAccessor: (row, col) ->
    "table-#{row}#{col}"

  populateCalendar: (month, year)->
    prev  = new Date year, month - 1, 0
    first = new Date year, month, 1
    last  = new Date year, month + 1, 0

    $("#month-year").html "#{@month2string(month)} #{year}"

    # index into table like "table-<row><col>"
    # <col> = day of week

    col = first.getDay() - 1
    row = 0
    day = prev.getDate()

    $('td').removeClass 'today'

    while col >= 0
      cell = $("\##{@getCalendarAccessor(row, col)}").find("div.date")
      cell.addClass('off').html day

      day--
      col--

    col = first.getDay()
    day = 1

    while row < 6 and day <= last.getDate()
      cell = $("\##{@getCalendarAccessor(row, col)}").find("div.date")

      cell.removeClass('off').html day

      if day is @today and month is @this_month and year is @this_year
        cell.parent().addClass 'today'

      ++day
      ++col

      if col % 7 == 0
        col = 0
        row++

    day = 1

    while row < 6
      cell = $("\##{@getCalendarAccessor(row, col)}")

      cell.find("div.date").addClass('off').html day

      ++day
      ++col

      if col % 7 == 0
        col = 0
        row++

  arrowHandler: (direction) ->
    that = this
    if direction is 'left'
      ->
        if that.current_month is 0
          that.current_year--
          that.current_month = 11
        else
          that.current_month--

        that.populateCalendar that.current_month, that.current_year
    else if direction is 'right'
      ->
        if that.current_month is 11
          that.current_year++
          that.current_month = 0
        else
          that.current_month++

        that.populateCalendar that.current_month, that.current_year


$(document).ready ->
  cal = new Calendar

  $(".arrow-left").click cal.arrowHandler('left')
  $(".arrow-right").click cal.arrowHandler('right')
