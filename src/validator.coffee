{ fun } = require './fun'

initTypes = ->
  arrayIf = ({ value, type }) ->
    value ?= 'value'
    elementType = type.slice 0, -2

    """
    if typeof #{value} isnt 'array'
      error = yes

    for element in #{value}
    #{entry(value: 'element', type: elementType).indent()}
    """

  coreTypes = ['Boolean', 'String']
  coreIf = ({ value, type }) ->
    """
    if typeof #{value} isnt '#{type.toLowerCase()}'
      error = yes
    """

  userTypes = @
  console.log userTypes
  userIf = ({ value, type }) ->
    console.log userTypes
    ifs = []
    
    for propName, propType of userTypes[type]
      propNameVariable = "#{value}_#{propName}"
      ifs.push """
        unless #{value}.hasOwnProperty #{propName}
          error = yes

        #{propNameVariable} = #{value}.#{propName}
        #{entry value: propNameVariable, type: propType}
      """

    ifs.join "\n\n"

  entry = (params) ->
    console.log params
    params.value ?= 'value'
    type = params.type

    if type.endsWith '[]'
      arrayIf params
    else if type in coreTypes
      coreIf params
    else
      userIf params

  entry


exports.Validate = fun
  init:
    types: initTypes
  call: (params) ->
    @types params
