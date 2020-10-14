String::indent = (options) ->
  number = options?.number or 2
  indentation = ' '.repeat number
  @split("\n")
    .map (line) -> "#{indentation}#{line}"
    .join("\n")
    #.slice(0, -number)
