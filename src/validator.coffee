exports.Validate = (types) ->
  userTypes = types
  userIf = ({ value, type }) ->
    ifs = []
    
    for propName, propType of userTypes[type]
      propNameVariable = "#{value}_#{propName}"
      ifs.push """
        unless #{value}.hasOwnProperty '#{propName}'
          throw "#{value} does not have prop '#{propName}'"

        #{propNameVariable} = #{value}['#{propName}']
        #{entry value: propNameVariable, type: propType}
      """

    ifs.join "\n\n"

  coreTypes = ['Boolean', 'String']
  coreIf = ({ value, type }) ->
    """
    if typeof #{value} isnt '#{type.toLowerCase()}'
      throw "#{value} is not #{type.toLowerCase()}"
    """

  arrayIf = ({ value, type }) ->
    value ?= 'value'
    elementType = type.slice 0, -2

    """
    unless Array.isArray #{value}
      throw "#{value} is not an array"

    for element in #{value}
    #{entry(value: 'element', type: elementType).indent()}
    """

  entry = (params) ->
    params.value ?= 'value'
    type = params.type

    if type.endsWith '[]'
      arrayIf params
    else if type in coreTypes
      coreIf params
    else
      userIf params

  entry
