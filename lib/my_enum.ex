defmodule MyEnum do
  @doc """
    Enum.all?/1 함수를 직접 구현해보자.
    리스트가 [] 빈 리스트일 경우에는 true를 반환한다.
    요소중 false 나 nil이 있으면 false를 반환한다.
  """
  def all?([]), do: true
  def all?([false | _]), do: false
  def all?([nil | _]), do: false
  def all?([_ | t]), do: all?(t)
  def all?(_), do: false

  @doc """
    Enum.all?/2 함수를 직접 구현해보자.
      리스트가 [] 빈 리스트일 경우에는 function이 false을 반환하는 요소가 없으므로 결과가 true가 나온다.
      사용자가 설정한 함수에 요소를 넣고 수행할 때 모두가 true라면 true를 반환한다.
  """
  def all?([], function), do: function.([])
  def all?([h | t], function), do: all?(t, function, function.(h))

  defp all?([_ | _], _, false), do: false
  defp all?([h | t], function, true), do: all?(t, function, function.(h))
  defp all?([], _, false), do: false
  defp all?([], _, true), do: true

  @doc """
    Enum.any?/1 함수를 직접 구현해보자.
    요소중 하나라도 true라면 즉시 true를 반환
    요소가 []일 경우에는 false를 반환합니다.
  """
  def any?([]), do: false
  def any?([nil | t]), do: any?(t)
  def any?([false | t]), do: any?(t)
  def any?([_ | _]), do: true
  def any?(_), do: false

  @doc """
    Enum.any?/2 함수를 직접 구현해보자.
    사용자가 설정한 함수에 요소를 넣고 수행할 때 하나라도 true라면 즉시 true를 반환
    요소가 []일 경우에는 false를 반환합니다.
  """
  def any?([h | t], function), do: any?(t, function, function.(h))
  defp any?([_ | _], _, true), do: true
  defp any?([], _, false), do: false
  defp any?([h | t], function, false), do: any?(t, function, function.(h))

  @doc """
    Enum.at/3 함수를 직접 구현해보자.
    index (zero-based)가 가르키는곳에 요소가 존재하는지 찾아주는 함수
    해당 인덱스에 요소가 없으면 default 값을 반환하는데 defalut 값을 설정하지 않으면 nil을 반환합니다.
    index를 음수로 입력하면 enumrable의 마지막부터 요소를 찾아갑니다.
    ex) Enum.at([1,2,3], -1) => 3을 반환.
    요소가 []일 경우에는 default를 반환합니다.
  """
  def at(list, index, default \\ nil) do
    at(list, index, default, 0)
  end

  defp at([], _, default, _), do: default
  defp at([h | _], index, _, depth) when index == depth, do: h
  defp at([_ | t], index, default, depth) when index > depth, do: at(t, index, default, depth + 1)

  defp at(list, index, default, depth) when index < depth,
    do: at(reverse(list), index * -1 - 1, default, depth)

  @doc """
    Enum.reverse/1 , Enum.reverse/2 함수를 직접 구현해보자.
    Enum.reverse/1는 주어진 리스트를 뒤집어 반환합니다.
    ex) Enum.reverse([1, 2, 3]) => [3, 2, 1]
    Enum.reverse/2는 주어진 리스트를 뒤집고 뒤집어진 리스트에 tail을 붙여 반환합니다.
    ex) Enum.reverse([1, 2, 3],[4, 5, 6]) => [3, 2, 1, 4, 5, 6]
  """

  def reverse([]), do: []
  def reverse([h | t]), do: reverse(t) ++ [h]
  def reverse(list, tail \\ []), do: reverse(list) ++ tail

  @doc """
    List.flatten/1, List.flatten/2 함수를 직접 구현해보자.
    List.flatten/1는 주어진 list에서 요소의 중첩목록을 없애 평탄화 한다.
    [] 빈 리스트의 경우는 삭제한다.
    List.flatten/2는 주어진 list에서 요소의 중첩목록을 없애 평탄화 작업을 한 이후에 tail을 붙여 반환한다.
  """

  def flatten(list, added_list \\ [])
  def flatten([], _), do: []
  def flatten([h | t], added_list), do: flatten(h) ++ flatten(t) ++ added_list
  def flatten(arg, []), do: [arg]

  @doc """
    Enum.concat/1 주어진 리스트의 요소들이 열거 가능한 요소들일 때 하나의 리스트로 요소들을 합친다.
    Enum.concat/2 주어진 열거 가능한 요소를 앞서 만든 리스트에 같이 합친다.
    ex ) [[1,[2],3], [4], [5,6]] => [1,[2],3,4,5,6]
  """
  def concat(list, enumerable \\ [])
  def concat([h | t], enumerable), do: h ++ concat(t) ++ enumerable
  def concat([], _), do: []

  @doc """
    Enum.count/1 주어진 리스트의 크기를 반환합니다.
    Enum.count/2 주어진 리스트의 요소중 제공한 함수를 만족하는 요소의 개수를 반환합니다.
  """
  def count(list, fun \\ fn _ -> true end) do
    count(list, fun, 0)
  end

  defp count([h | t], fun, count) do
    case fun.(h) do
      true -> count(t, fun, count + 1)
      false -> count(t, fun, count)
    end
  end

  defp count(_list, _fun, count), do: count

  @doc """
    Enum.count_until/2 주어진 리스트의 갯수가 적어도 limit 또는 limit 값 이상인지 확인할 때 사용한다.
    Enum.count_until/3 주어진 리스트의 요소중 제공한 함수를 만족하는 요소의 개수가 적어도 limit 또는 limit값 이상인지 확인할 때 사용한다.
    limit은 0이 될 수 없다.
  """

  def count_until(list, limit, function \\ fn _ -> true end) do
    count_until(list, limit, 0, function)
  end

  defp count_until([h | t], limit, count, function) when limit > count do
    case function.(h) do
      true -> count_until(t, limit, count + 1, function)
      false -> count_until(t, limit, count, function)
    end
  end

  defp count_until(_list, _limit, count, _function), do: count

  @doc """
    Enum.dedup/1 리스트에서 순서대로 중복되어 연속된 요소가 있을 시 중복된 요소를 하나로 축소시키는 함수
  """

  def dedup([h | t]), do: dedup(t, [h], h)
  def dedup(_list), do: []

  # 1. 패턴 매칭을 통한 구현
  defp dedup([h | t], result, arg), do: dedup(t, result, h, h === arg)
  defp dedup([h | t], result, arg, true), do: dedup(t, result, h, h === arg)
  defp dedup([h | t], result, arg, false), do: dedup(t, result ++ [arg], h, h === arg)
  defp dedup(_list, result, _arg, true), do: result
  defp dedup(_list, result, arg, false), do: result ++ [arg]

  # 2. case를 사용한 구현
  # defp dedup([h|t], result, arg) do
  #   case h === arg do
  #     true -> dedup(t,result,h)
  #     false -> dedup(t, result ++ [h], h)
  #   end
  # end
  # defp dedup(_list, result,_arg), do: result

  @doc """
    Enum.dedup_by/2 리스트에서 주어진 함수를 만족하는 요소가 반복되어 나열됐을 때 반복된 요소를 함수를 처음 만족한 요소 하나로 축소시키는 함수
  """

  def dedup_by([h | t], function), do: dedup_by(t, function, h, [h])
  def dedup_by(_list, _function), do: []

  defp dedup_by([h | t], function, arg, result) do
    case function.(h) === function.(arg) do
      true -> dedup_by(t, function, h, result)
      false -> dedup_by(t, function, h, result ++ [h])
    end
  end

  defp dedup_by(_list, _function, _arg, result), do: result

  @doc """
    Enum.drop/2 리스트에서 amount만큼 차례로 요소를 삭제해 나갑니다.
    음수 amount가 주어지면 리스트의 마지막 요소부터 삭제해 나갑니다.
  """

  def drop([], _amount), do: []
  def drop(list, 0), do: list

  def drop(list, amount) when amount < 0 do
    list
    |> reverse()
    |> drop(amount * -1)
    |> reverse()
  end

  def drop([_h | t], amount), do: drop(t, amount - 1)

  @doc """
    Enum.drop_every/2 리스트에서 주어진 nth 간격으로 요소를 삭제해 나갑니다.
    맨처음 요소는 항상 삭제되며 주어지는 nth는 음수 값이 될 수 없습니다.
  """

  def drop_every([], _), do: []
  def drop_every(_list, 1), do: []
  def drop_every(_list, nth) when nth < 0, do: []
  def drop_every(list, 0), do: list
  def drop_every([_ | t], nth), do: drop_every(t, nth, 1, [])

  defp drop_every([], _nth, _depth, result), do: result

  defp drop_every([h | t], nth, depth, result) do
    case nth - depth == 0 do
      true -> drop_every(t, nth, 1, result)
      false -> drop_every(t, nth, depth + 1, result ++ [h])
    end
  end

  @doc """
    Enum.drop_while/2 리스트에서 함수에 만족하는 요소를 삭제해 나갑니다.
  """

  def drop_while([], _), do: []
  def drop_while(list, function), do: drop_while(list, function, [])

  defp drop_while([], _function, result), do: result

  defp drop_while([h | t], function, result) do
    case function.(h) do
      true -> drop_while(t, function, result)
      false -> drop_while(t, function, result ++ [h])
    end
  end

  @doc """
    Enum.each/2 요소를 순회하며 주어진 함수에 요소값을 넣어 실행합니다.
    요소를 모두 순회하면 :ok를 반환합니다.
  """

  def each([], _function), do: :ok

  def each([h | t], function) do
    function.(h)
    each(t, function)
  end

  @doc """
    Enum.empty?/1 리스트가 비어있는지 확인합니다.
    비어있으면 true 그렇지 않으면 false를 반환합니다.
  """

  def empty?([]), do: true
  def empty?([_h | _t]), do: false

  @doc """
    fetch!/2 주어진 index의 요소를 반환합니다.
    index는 zero base 입니다.
    index가 음수로 전해지면 요소의 맨 뒤에서 부터 순회합니다.
    index가 리스트의 범위를 벗어나면 OutOfBoundsError가 발생합니다.
  """
  def fetch!([h | _t], 0), do: h

  def fetch!(list, index) when index < 0 do
    list
    |> MyEnum.reverse()
    |> fetch!(index * -1 - 1)
  end

  def fetch!([_ | t], index), do: fetch!(t, index - 1)

  @doc """
    fetch/2 주어진 index의 요소를 {:ok, element } 형식으로 반환합니다.
    index는 zero base 입니다.
    index가 음수로 전해지면 요소의 맨 뒤에서 부터 순회합니다.
    index가 리스트의 범위를 벗어나면 OutOfBoundsError가 발생합니다.
    해당 index에 요소가 없다면 :error를 반환합니다.
  """

  def fetch([h | _t], 0), do: {:ok, h}

  def fetch(list, index) when index < 0 do
    list
    |> MyEnum.reverse()
    |> fetch(index * -1 - 1)
  end

  def fetch([_ | t], index), do: fetch(t, index - 1)

  def fetch([], _index), do: :error

  @doc """
    filter/2 리스트에서 주어진 함수에 요소를 넣어 truthy가 나오는 요소들만 반환한다.
  """

  def filter([], _function), do: []
  def filter(list, function), do: filter(list, function, [])

  defp filter([], _function, result), do: result

  defp filter([h | t], function, result) do
    case function.(h) do
      true -> filter(t, function, result ++ [h])
      false -> filter(t, function, result)
    end
  end

  @doc """
    find/3 리스트에서 주어진 함수에 truthy한 값을 반환하는 첫번째 요소를 찾아 반환한다.
    리스트안에 그런 요소가 존재하지 않을 경우 default 값을 반환한다.
  """

  def find(list, default \\ nil, function)
  def find([], default, _function), do: default

  def find([h | t], default, function) do
    case function.(h) do
      true -> h
      false -> find(t, default, function)
    end
  end

  @doc """
    find_index/2 find/3와 유사하지만 함수에 truthy한 값을 반환하는 첫번째 요소의 인덱스를 반환합니다.
    truthy한 요소가 없으면 nil을 반환합니다.
  """

  def find_index([], _function), do: nil
  def find_index(list, function), do: find_index(list, function, 0)

  defp find_index([], _function, _depth), do: nil

  defp find_index([h | t], function, depth) do
    case function.(h) do
      true -> depth
      false -> find_index(t, function, depth + 1)
    end
  end

  @doc """
    find_value/3 find/3와 유사하지만 요소 자체 대신 함수 호출 값을 반환한다.
    반환 값은 함수의 결과에 참일 때 찾은 것으로 간주한다. (nil 이나 false가 아닌경우 참)
    찾지못하면 반환값으로 default \\ nil 값을 반환한다.
  """

  def find_value(list, default \\ nil, function)
  def find_value([], default, _function), do: default

  def find_value([h | t], default, function) do
    result = function.(h)

    case result do
      nil -> find_value(t, default, function)
      false -> find_value(t, default, function)
      _ -> result
    end
  end

  @doc """
    flat_map/2 주어진 함수를 요소에 적용하여 나온 결과를 매핑하고 하나의 리스트로 합치는 평탄화를 진행한다.
    함수의 매핑 결과는 열거 가능한 형식의 요소를 반환해야합니다.
  """

  def flat_map([], _function), do: []
  def flat_map([h | t], function), do: function.(h) ++ flat_map(t, function)

  @doc """
    flat_map_reduce/3 리스트의 요소를 함수를 적용하여 나온 결과를 매핑하고 한단계의 평탄화를 거쳐 하나의 리스트로 합치며
    함수를 실행하여 나온 누산 결과를 계속적으로 더해서 마지막에 돌려준다.
    함수에 제공하는 인자는 2개가 되야한다.
  """

  def flat_map_reduce(list, acc, function), do: flat_map_reduce(list, acc, function, [])
  defp flat_map_reduce([], acc, _function, result), do: {result, acc}

  defp flat_map_reduce([h | t], acc, function, result) do
    case function.(h, acc) do
      {:halt, next_acc} -> flat_map_reduce(t, next_acc, function, result)
      {x, next_acc} -> flat_map_reduce(t, next_acc, function, result ++ x)
    end
  end

  @doc """
    frequencies/1 요소가 리스트내에서 얼마나 반복되는지를 맵으로 변환하여 반환합니다.
  """

  def frequencies(list), do: frequencies(list, %{})
  defp frequencies([], result), do: result

  defp frequencies([h | t], result) do
    value = result[h]

    case value do
      nil -> frequencies(t, Map.put(result, h, 1))
      value -> frequencies(t, Map.put(result, h, value + 1))
    end
  end

  @doc """
    frequencies_by/2 주어진 함수로 요소에 적용하며 만들어진 키값이 얼마나 반복되는지를 맵으로 변환하여 반환합니다.
  """

  def frequencies_by(list, key_function), do: frequencies_by(list, key_function, %{})
  defp frequencies_by([], _key_function, result), do: result

  defp frequencies_by([h | t], key_function, result) do
    new_key = key_function.(h)
    value = result[new_key]

    case value do
      nil -> frequencies_by(t, key_function, Map.put(result, new_key, 1))
      value -> frequencies_by(t, key_function, Map.put(result, new_key, value + 1))
    end
  end

  @doc """
    group_by/3 제공한 key_function 함수를 사용하여 요소를 적용하여 나온 Key를 만족하는 요소들을 그룹화하고
    제공한 value_fun으로 value에 저장되는 요소를 변환 시킵니다. value_fun을 제공하지 않을경우에는 default 값으로
    fn x -> x end 값이 들어갑니다.
  """

  def group_by(list, key_function, value_function \\ fn x -> x end)

  def group_by(list, key_function, value_function),
    do: group_by(list, key_function, value_function, %{})

  defp group_by([], _key_function, _value_function, result), do: result

  defp group_by([h | t], key_function, value_function, result) do
    new_key = key_function.(h)
    new_value = value_function.(h)
    value = result[new_key]

    case value do
      nil ->
        group_by(t, key_function, value_function, Map.put(result, new_key, [new_value]))

      value ->
        group_by(t, key_function, value_function, Map.put(result, new_key, value ++ [new_value]))
    end
  end

  @doc """
    intersperse/2 리스트 요소 사이에 구분자를 넣습니다.
    요소가 하나일 경우에는 바로 반환합니다 [1] ==> [1]
    요소가 빈 경우 []를 반환합니다.
  """

  def intersperse(list, seperator), do: intersperse(list, seperator, 0, [])
  defp intersperse([], _sperator, _depth, result), do: result

  defp intersperse([h | t], seperator, depth, result) do
    case rem(depth, 2) == 0 do
      true -> intersperse(t, seperator, depth + 1, result ++ [h])
      false -> intersperse([h | t], seperator, depth + 1, result ++ [seperator])
    end
  end

  @doc """
    into/3 리스트의 요소에서 함수를 적용하여 나온값을 주어진 colletable에 변환하여 넣습니다.
  """
  def into([], colletable), do: colletable
  def into([h | t], colletable) when is_list(colletable), do: into(t, colletable ++ [h])

  def into([h | t], colletable) when is_map(colletable) do
    {k, v} = h
    new_map = Map.put(colletable, k, v)
    into(t, new_map)
  end

  # map의 키를 바인딩 하는 방법을 몰라서 comprehension으로 구현했습니다.
  # 리뷰 부탁드립니다 !!
  def into(map, colletable) when is_map(map) do
    for {k, v} <- map, into: colletable, do: {k, v}
  end

  @doc """
    join/2 구분 기호로 사용하여 주어진 joiner로 요소들을 문자열로 결합합니다.
    joiner가 주어지지 않으면 default 값인 "" 빈 문자열이 사용됩니다.
    모든 요소는 문자열로 변환할 수 있어야 합니다.
  """
  def join(list, joiner \\ ""), do: join(list, joiner, 0, "")
  defp join([], _joiner, _depth, result), do: result

  defp join([h | t], joiner, depth, result) do
    case rem(depth, 2) == 0 do
      true -> join(t, joiner, depth + 1, result <> "#{h}")
      false -> join([h | t], joiner, depth + 1, result <> joiner)
    end
  end

  @doc """
    map/2 각 요소에 함수를 적용한 값으로 요소를 변환해 list 형식으로 반환합니다
    map, keywordlist 요소에 대해서는 함수 파라미터로 key-value tuple로 패턴매칭되는 함수를 제공해야합니다.
  """

  def map([], _function), do: []
  def map([h | t], function), do: [function.(h)] ++ map(t, function)
  def map(map, function), do: for({k, v} <- map, into: [], do: function.({k, v}))

  @doc """
    map_every/3 모든 요소에서 주어진 nth번째의 요소에 주어진 함수를 호출하여 나온 결과 목록을 반환합니다.
    nth가 0일때는 주어진 리스트 그대로 반환이되고
    nth가 1이상일 때는 요소에서 nth번째의 요소에 함수를 호출하는데 첫 번째 인자는 무조건적으로 항상 함수를 적용합니다.
    nth는 음이 아닌 정수여야 합니다.
  """
  def map_every(list, 0, _function), do: list

  def map_every(map, nth, function) when is_map(map),
    do: map_every(Enum.to_list(map), nth, function)

  def map_every(list, nth, function), do: map_every(list, nth, function, 0)
  defp map_every([], _nth, _function, _now_nth), do: []

  defp map_every([h | t], nth, function, 0),
    do: [function.(h)] ++ map_every(t, nth, function, nth - 1)

  defp map_every([h | t], nth, function, now_nth),
    do: [h] ++ map_every(t, nth, function, now_nth - 1)

  @doc """
    map_intersperse/3 모든 요소에 사이에 separator 요소를 넣고 주어진 함수에 요소를 매핑한다.
  """

  def map_intersperse([], _separator, _mapper), do: []

  def map_intersperse([h | [ht | t]], separator, mapper),
    do:
      [mapper.(h)] ++
        [separator] ++ [mapper.(ht)] ++ [separator] ++ map_intersperse(t, separator, mapper)

  def map_intersperse([h | _t], _separator, mapper), do: [mapper.(h)]

  @doc """
    map_join/3 모든 요소 사이에 joiner를 넣고 요소에 함수를 적용하며 하나의 문자열로 합하여 요소를 매핑한다.
    joiner가 주어지지않으면 default 값으로 빈 문자열 "" 가 들어갑니다.
  """

  def map_join(list, joiner \\ "", mapper)
  def map_join([], _joiner, _mapper), do: ""

  def map_join([h | [ht | t]], joiner, mapper),
    do:
      "#{mapper.(h)}" <>
        joiner <> "#{mapper.(ht)}" <> joiner <> map_join(t, joiner, mapper)

  def map_join([h | _t], _joiner, mapper), do: "#{mapper.(h)}"

  @doc """
    map_reduce/3 리스트의 요소를 함수를 적용하여 나온 결과를 매핑하고
    함수를 실행하여 나온 누산 결과를 계속적으로 더해서 마지막에 돌려준다.
    함수에 제공하는 인자는 2개가 되야한다.
    맵이 제공될 경우 첫번째 튜플요소는 반드시 {key, value} 튜플이어야한다.
  """

  def map_reduce(list, acc, function), do: map_reduce(list, acc, function, [])
  defp map_reduce([], acc, _function, result), do: {result, acc}

  defp map_reduce([h | t], acc, function, result) do
    {x, next_acc} = function.(h, acc)
    map_reduce(t, next_acc, function, result ++ [x])
  end

  @doc """

    max/3 주어진 요소에서 가장 큰 요소를 반환합니다.
    가장 큰 요소의 산출 기준은 Erlang의 용어 순서에 따라 산출하고 용어 순서는 다음과 같다.
    number < atom < reference < function < port < pid < tuple < map < list < bitstring

    기본적인 비교는 >= sorter 함수로 수행되고, 모든 요소가 최대로 간주되는 경우 첫번째 요소를 반환한다.
    만약 첫번째 요소를 반환하지 않고 마지막 요소를 반환하고 싶다면 분류 함수에서 동일한 요소에 대해서 true를 반환하지 않으면 된다.

    열거 가능한 항목이 비어 있으면 제공된 항목 empty_fallback이 호출된다 default 값은 fn -> raise Enum.EmptyError이다.
  """

  def max(list, sorter \\ &>=/2, empty_fallback \\ fn -> raise Enum.EmptyError end)
  def max([], _sorter, empty_fallback), do: empty_fallback.()
  def max([h | t], sorter, empty_fallback), do: max(t, sorter, empty_fallback, h)

  defp max([], _sorter, _empty_fallback, max), do: max

  # 모든 구조체에 비교를 위한 compare 함수가 제공되었다는 가정하에 구현 하였습니다.
  # 모듈명은 atom이기 때문에 sorter가 function이 아닌경우를 체크할 수 있다.
  defp max([h | t], sorter, empty_fallback, max) when is_atom(sorter) do
    case sorter.compare(h, max) do
      :gt -> max(t, sorter, empty_fallback, h)
      :lt -> max(t, sorter, empty_fallback, max)
      :eq -> max(t, sorter, empty_fallback, h)
    end
  end

  defp max([h | t], sorter, empty_fallback, max) do
    case sorter.(h, max) do
      true -> max(t, sorter, empty_fallback, h)
      false -> max(t, sorter, empty_fallback, max)
    end
  end

  @doc """
    max_by/4 주어진 요소에서 함수를 적용하여 가장 큰 요소를 반환합니다.
    가장 큰 요소의 산출 기준은 max/1 함수와 동일하게 Erlang의 용어 순서에 따라 산출합니다.

    기본적인 비교는 >= sorter 함수로 수행되고, 모든 요소가 최대로 간주되는 경우 첫번째 요소를 반환한다.
    만약 첫번째 요소를 반환하지 않고 마지막 요소를 반환하고 싶다면 분류 함수에서 동일한 요소에 대해서 true를 반환하지 않으면 된다.

    열거 가능한 항목이 비어 있으면 제공된 항목 empty_fallback이 호출된다 default 값은 fn -> raise Enum.EmptyError이다.
  """

  def max_by(list, function, sorter \\ &>=/2, empty_fallback \\ fn -> raise Enum.EmptyError end)
  def max_by([], _fucntion, _sorter, empty_fallback), do: empty_fallback.()

  def max_by([h | t], function, sorter, empty_fallback),
    do: max_by(t, function, sorter, empty_fallback, h)

  defp max_by([], _function, _sorter, _empty_fallback, max), do: max

  # 모듈명은 atom이기 때문에 sorter가 function이 아닌경우를 체크할 수 있다.
  defp max_by([h | t], function, sorter, empty_fallback, max) when is_atom(sorter) do
    new_h = function.(h)
    new_max = function.(max)

    case sorter.compare(new_h, new_max) do
      :gt -> max_by(t, function, sorter, empty_fallback, h)
      :lt -> max_by(t, function, sorter, empty_fallback, max)
      :eq -> max_by(t, function, sorter, empty_fallback, h)
    end
  end

  defp max_by([h | t], function, sorter, empty_fallback, max) do
    new_h = function.(h)
    new_max = function.(max)

    case sorter.(new_h, new_max) do
      true -> max_by(t, function, sorter, empty_fallback, h)
      false -> max_by(t, function, sorter, empty_fallback, max)
    end
  end

  @doc """
    member?/2 리스트의 요소에서 주어진 element가 존재하는지 확인하는 함수
  """
  def member?([], _element), do: false

  def member?([h | t], element) do
    case h === element do
      true -> true
      false -> member?(t, element)
    end
  end

  @doc """
    min/3 리스트의 요소에서 가장 작은 값을 반환합니다. max/3 함수와 반대로 동작하는 함수입니다.
    sorter가 적용되지 않으면 default 값으로 &<=/2로 비교연산을 합니다.
    빈 리스트가 들어오면 empty_fallback를 반환합니다. default값으로 fn raise Enum.EmptyError end를 반환합니다.
  """
  def min(list, sorter \\ &<=/2, empty_fallback \\ fn -> raise Enum.EmptyError end)
  def min([], _sorter, empty_fallback), do: empty_fallback.()
  def min([h | t], sorter, empty_fallback), do: min(t, sorter, empty_fallback, h)

  defp min([], _sorter, _empty_fallback, min), do: min

  # 구조체가 비교를 위한 함수인 compare/2 함수를 제공한다는 가정하에 구현.
  # 모듈명은 atom이기 때문에 sorter가 function이 아닌경우를 체크할 수 있다.
  defp min([h | t], sorter, empty_fallback, min) when is_atom(sorter) do
    case sorter.compare(h, min) do
      :gt -> min(t, sorter, empty_fallback, min)
      :lt -> min(t, sorter, empty_fallback, h)
      :eq -> min(t, sorter, empty_fallback, min)
    end
  end

  defp min([h | t], sorter, empty_fallback, min) do
    case sorter.(h, min) do
      true -> min(t, sorter, empty_fallback, h)
      false -> min(t, sorter, empty_fallback, min)
    end
  end

  @doc """
    min_by/4 리스트의 요소에서 함수를 적용하여 가장 작은 값을 반환합니다. max_by/4 함수와 반대로 동작하는 함수이다.
    min/3 과 같이 빈 리스트가 들어오면 empty_fallback를 반환합니다.
  """

  def min_by(list, function, sorter \\ &<=/2, empty_fallback \\ fn -> raise Enum.EmptyError end)
  def min_by([], _function, _sorter, empty_fallback), do: empty_fallback.()

  def min_by([h | t], function, sorter, empty_fallback),
    do: min_by(t, function, sorter, empty_fallback, h)

  defp min_by([], _function, _sorter, _empty_fallback, min), do: min

  # 모듈명은 atom이기 때문에 sorter가 function이 아닌경우를 체크할 수 있다.
  defp min_by([h | t], function, sorter, empty_fallback, min) when is_atom(sorter) do
    new_h = function.(h)
    new_min = function.(min)

    case sorter.compare(new_h, new_min) do
      :gt -> min_by(t, function, sorter, empty_fallback, min)
      :lt -> min_by(t, function, sorter, empty_fallback, h)
      :eq -> min_by(t, function, sorter, empty_fallback, min)
    end
  end

  defp min_by([h | t], function, sorter, empty_fallback, min) do
    new_h = function.(h)
    new_min = function.(min)

    case sorter.(new_h, new_min) do
      true -> min_by(t, function, sorter, empty_fallback, h)
      false -> min_by(t, function, sorter, empty_fallback, min)
    end
  end

  @doc """
    min_max/2 Erlang의 용어 순서에 따라 모든 요소를 순회하며 최소 및 최대 요소가 있는 튜플을 반환합니다.
    모든 요소가 최대 또는 최소로 간주되는 경우 발견된 첫 번째 요소가 반환됩니다.
  """
  def min_max(list, empty_fallback \\ fn -> raise Enum.EmptyError end)
  def min_max([], empty_fallback), do: empty_fallback.()
  def min_max([h | t], _empty_fallback), do: {min_max(t, h, &<=/2), min_max(t, h, &>=/2)}

  defp min_max([], mix_max_value, _sorter), do: mix_max_value

  defp min_max([h | t], mix_max_value, sorter) do
    case sorter.(h, mix_max_value) do
      true -> min_max(t, h, sorter)
      false -> min_max(t, mix_max_value, sorter)
    end
  end

  @doc """
    min_max_by/4 주어진 함수에 의해 계산된 요소중에서 최소 및 최대요소를 튜플로 반환합니다.
    여러 요소가 최대 또는 최소로 간주되는 경우 발견된 첫 번째 요소가 반환됩니다.
  """
  def min_max_by(
        list,
        fun,
        sorter_or_empty_fallback \\ &</2,
        empty_fallback \\ fn -> raise Enum.EmptyError end
      )

  # sorter_or_empty_fallback에서 arity가 0인 함수는 empty_fallback이다.
  # 왜냐하면 비교를 위한 함수는 인자가 2개 이상을 넣어야하기 때문
  def min_max_by([], _fun, sorter_or_empty_fallback, _empty_fallback)
      when is_function(sorter_or_empty_fallback, 0),
      do: sorter_or_empty_fallback.()

  def min_max_by([], _fun, _sorter_or_empty_fallback, empty_fallback), do: empty_fallback.()

  def min_max_by([h | t], fun, sorter, _empty_fallback),
    do: {min_max_by(t, fun, sorter, h, :min), min_max_by(t, fun, sorter, h, :max)}

  defp min_max_by([], _fun, _sorter, min_max, _get_min_max_mode), do: min_max

  # 최대값을 구함.
  defp min_max_by([h | t], fun, sorter, min_max, :max) when is_atom(sorter) do
    new_value = fun.(h)
    new_min_max = fun.(min_max)

    case sorter.compare(new_value, new_min_max) do
      :gt -> min_max_by(t, fun, sorter, h, :max)
      :lt -> min_max_by(t, fun, sorter, min_max, :max)
      :eq -> min_max_by(t, fun, sorter, min_max, :max)
    end
  end

  # 최소값을 구함.
  defp min_max_by([h | t], fun, sorter, min_max, :min) when is_atom(sorter) do
    new_value = fun.(h)
    new_min_max = fun.(min_max)

    case sorter.compare(new_value, new_min_max) do
      :gt -> min_max_by(t, fun, sorter, min_max, :min)
      :lt -> min_max_by(t, fun, sorter, h, :min)
      :eq -> min_max_by(t, fun, sorter, min_max, :min)
    end
  end

  # 최대값을 구함.
  defp min_max_by([h | t], fun, sorter, min_max, :max) do
    new_value = fun.(h)
    new_min_max = fun.(min_max)

    cond do
      # sorter가 &</2로 제공되므로 같은 값인 경우를 대비하여 한번의 체크가 필요하다.
      new_value === new_min_max -> min_max_by(t, fun, sorter, min_max, :max)
      sorter.(new_value, new_min_max) -> min_max_by(t, fun, sorter, min_max, :max)
      !sorter.(new_value, new_min_max) -> min_max_by(t, fun, sorter, h, :max)
    end
  end

  # 최소값을 구함.
  defp min_max_by([h | t], fun, sorter, min_max, :min) do
    new_value = fun.(h)
    new_min_max = fun.(min_max)

    # 최소값의 경우에는 같으면 기존의 최소값을 넣으면 되기때문에 같은 값에 대한 처리가 필요없음.
    case sorter.(new_value, new_min_max) do
      true -> min_max_by(t, fun, sorter, h, :min)
      false -> min_max_by(t, fun, sorter, min_max, :min)
    end
  end

  @doc """
    product/1 모든 요소를 곱한 값을 반환합니다
  """
  def product([]), do: 1
  def product([h | t]), do: h * product(t)

  @doc """
    reduce/2 모든 요소에 함수를 적용하여 나온값을 누산하여 반환합니다.
  """

  def reduce([], acc, _fun), do: acc
  def reduce([h | t], acc, fun), do: reduce(t, fun.(h, acc), fun)

  @doc """
    reduce_while/3 함수의 결과가 fun {:halt, acc}를 반환하면 더이상 순회를 하지않고 누산된 결과를 반환합니다.
    { :cont, acc }를 반환하면 계속해서 누산을 진행합니다.
    더 이상 요소가 존재하지 않거나 리스트가 비어있으면 acc를 반환합니다.
  """

  def reduce_while([], acc, _fun), do: acc

  def reduce_while([h | t], acc, fun) do
    case fun.(h, acc) do
      {:cont, new_acc} -> reduce_while(t, new_acc, fun)
      {:halt, new_acc} -> new_acc
    end
  end

  @doc """
    reject/2 함수의 결과로 false 값을 반환하는 요소들만 리스트로 반환합니다.
  """
  def reject([], _fun), do: []

  def reject([h | t], fun) do
    case fun.(h) do
      true -> reject(t, fun)
      false -> [h] ++ reject(t, fun)
    end
  end

  @doc """
    reverse_slice/3 리스트에서 start_index 부터 시작하여 count 만큼 요소를 반대로 뒤집은 리스트를 반환합니다.
  """

  def reverse_slice(list, start_index, count), do: reverse_slice(list, start_index, count, [], [])

  defp reverse_slice([], _start_index, _count, result, reverse_result),
    do: result ++ reverse_result

  defp reverse_slice([h | t], _start_index, 0, result, _reverse_result),
    do: reverse_slice(t, 0, 0, result ++ [h], [])

  defp reverse_slice([h | t], 0, 1, result, reverse_result),
    do: reverse_slice(t, 0, 1, result ++ [h] ++ reverse_result, [])

  defp reverse_slice([h | t], 0, count, result, reverse_result),
    do: reverse_slice(t, 0, count - 1, result, [h] ++ reverse_result)

  defp reverse_slice([h | t], start_index, count, result, reverse_result),
    do: reverse_slice(t, start_index - 1, count, result ++ [h], reverse_result)

  @doc """
    scan/2 주어진 함수를 각 요소에 적용하여 나온 결과를 리스트 순차별로 저장하고 다음 계산을 위한 누산기로 전달합니다.
    scan/3 주어진 함수를 각 요소에 적용하고 결과를 목록에 저장하고 다음 계산을 위한 누산기를 acc로 시작 값으로 사용합니다.
  """

  def scan([], _fun), do: []
  def scan([h | t], fun), do: [h] ++ scan(t, h, fun)
  def scan([], _acc, _fun), do: []

  def scan([h | t], acc, fun) do
    new_acc = fun.(h, acc)
    [new_acc] ++ scan(t, new_acc, fun)
  end

  @doc """
    slice/2 주어진 리스트에서 index_range만큼 잘라낸 값들을 반환합니다.
    주어진 index_range에서의 범위는 zero_base로 index 부터 range까지입니다.
    ex) [1,2,3,4,5] , 2..3 => 2번째 인덱스인 3부터 4까지인 [3, 4]를 반환

    index는 정규화되어 만약 음수가 주어진다면 요소의 마지막부터 잘라내기를 시작합니다.
    이때는 zero_base가 아닌 -1이 마지막 요소를 가르킵니다.
    ex) [1,2,3,4,5] => -1 은 5 , -2 는 4 , -3은 3, -4는 2, -5는 1
    ex) [1,2,3,4,5], -4..-3 =>  [2, 3]를 반환

    index_range.first가 요소 범위보다 크면 []를 반환합니다.
    ex) [1,2,3,4,5], 5..10 => []를 반환

    index_range.last가 요소 범위보다 크면 해당하는 요소까지만 반환합니다.
    ex) [1,2,3,4,5], 2..20 => [3, 4, 5]를 반환

    ========================================================================

    slice/3 리스트에서 start_index (zero_base)부터 시작하여 amount 갯수만큼 요소를 잘라내어 반환합니다.
    amount의 개수가 요소보다 많으면 더 이상 요소를 가져올수 없을만큼 최대한 잘라냅니다.

    start_index가 음수로 주어지게 되면 리스트의 마지막부터 잘라내기를 시작합니다.
    ex) [1,2,3,4,5], -1 ,2 => 4,5

    amount가 0 이거나 start_index가 요소의 범위를 벗어났을경우 []를 반환합니다.
  """

  def slice(list, first..last), do: slice(list, first, last - first + 1)

  def slice([], _start_index, _amount), do: []
  def slice([_h | _t], _start_index, 0), do: []
  def slice([h | _t], 0, 0), do: [h]
  def slice([h | t], 0, amount), do: [h] ++ slice(t, 0, amount - 1)

  def slice(list, start_index, amount) when start_index < 0 do
    new_start_index = -start_index - amount

    case new_start_index >= 0 do
      true ->
        MyEnum.reverse(list)
        |> slice(new_start_index, amount)
        |> MyEnum.reverse()

      false ->
        MyEnum.reverse(list)
        |> slice(0, -start_index)
        |> MyEnum.reverse()
    end
  end

  def slice([_h | t], start_index, amount), do: slice(t, start_index - 1, amount)

  @doc """
    split/2 요소를 count 만큼 {left, right}로 나눕니다.
    count가 양수일때는 왼쪽에 남겨질 요소의 개수를 뜻하고
    count가 음수일때는 오른쪽에 남겨질 요소의 개수를 뜻합니다.

    ex ) Enum.split([1, 2, 3], 2) => {[1, 2], [3]}
    ex ) Enum.split([1, 2, 3],-2) => {[1], [2, 3]}
  """

  def split(list, count) when count < 0 do
    reverse_list = reverse(list)
    {left, right} = split(reverse_list, count * -1)
    {reverse(right), reverse(left)}
  end

  def split(list, count), do: split(list, count, [])

  defp split([], _count, result), do: {result, []}
  defp split([h | t], 0, result), do: {result, [h] ++ t}
  defp split([h | t], count, result), do: split(t, count - 1, result ++ [h])

  @doc """
    split_while/2 function에 true 값을 반환하는 요소를 left에 넣다가 false 값 ( false 또는 nil )을 반환하는 요소를 만날시부터
    right에 값을 넣어 반환합니다.
    ex ) Enum.split_while([1,2,3,4], fn x -> x < 3 end ) => {[1, 2], [3, 4]}
  """

  def split_while(list, fun), do: split_while(list, fun, [])
  defp split_while([], _fun, left_result), do: {left_result, []}

  defp split_while([h | t], fun, left_result) do
    case fun.(h) do
      true -> split_while(t, fun, left_result ++ [h])
      _ -> {left_result, [h] ++ t}
    end
  end

  @doc """
    split_with/2 모든 요소를 순회하며 함수에 true 값을 반환하는 요소는 left에 함수에 false 값 ( false , nil )을 반환하는 요소는 right에 넣습니다.

    반환하는 튜플인 {left, right}의 각 left, right에 요소들은 기존에 제공한 요소의 순서와 동일한 순서로 적재됩니다.
    ex ) split_with([1,5,4,2,3], fn x -> rem(x,2) == 0 end)
    => {[2, 4], [1, 3, 5]} ( X ) 순서가 정렬되지 않는다.
    => {[4, 2], [1, 5, 3]} ( O ) 처음 제공한 순서대로 반환됩니다.
  """

  def split_with(map, fun) when is_map(map), do: split_with(Enum.to_list(map), fun, [], [])
  def split_with(list, fun), do: split_with(list, fun, [], [])
  defp split_with([], _fun, left, right), do: {left, right}

  defp split_with([h | t], fun, left, right) do
    case fun.(h) do
      true -> split_with(t, fun, left ++ [h], right)
      _ -> split_with(t, fun, left, right ++ [h])
    end
  end

  @doc """
    sum/1 모든 요소의 합계를 반환합니다. 요소가 숫자가 아니면 ArithmeticError를 발생시킵니다.
  """
  def sum([]), do: 0

  def sum([h | _t]) when is_number(h) == false,
    do: raise(ArithmeticError.exception("It's not number"))

  def sum([h | t]), do: h + sum(t)

  @doc """
    take/2 주어진 요소에서 amount 만큼의 요소를 반환합니다.
    amount가 음수의 경우에 요소의 끝에서부터 가져옵니다.
  """

  def take([], _amount), do: []
  def take([_h | _t], 0), do: []

  def take(list, amount) when amount < 0 do
    reverse(list)
    |> take(amount * -1)
    |> reverse()
  end

  def take([h | t], amount), do: [h] ++ take(t, amount - 1)

  @doc """
    take_every/2 주어진 요소에서 nth간격 만큼 요소를 가져옵니다.
    nth가 0이 아닐때 첫 번째 요소는 항상 포함됩니다.
    nth는 음이 아닌 정수여야합니다.
  """

  def take_every([], _nth), do: []
  def take_every(_list, 0), do: []
  def take_every([h | t], nth), do: [h] ++ take_every(t, nth, nth - 1)
  defp take_every([], _nth, _depth), do: []
  defp take_every([h | t], nth, 0), do: [h] ++ take_every(t, nth, nth - 1)
  defp take_every([_h | t], nth, depth), do: take_every(t, nth, depth - 1)

  @doc """
    take_while/2 요소에서 fun를 호출하여 false가 나오기 전까지의 요소들을 반환합니다.
  """
  def take_while([], _fun), do: []

  def take_while([h | t], fun) do
    case fun.(h) do
      true -> [h] ++ take_while(t, fun)
      _ -> []
    end
  end

  @doc """
    uniq/1 모든 요소에서 중복 요소를 제거하여 반환합니다.
  """

  def uniq([]), do: []

  def uniq([h | t]) do
    [h] ++ uniq(reject(t, fn x -> x === h end))
  end

  @doc """
    uniq_by/2 요소를 순회하며 함수의 호출결과로 나온 결과가 중복되는 요소를 제거하여 반환합니다.
    각 요소의 첫 번째 항목이 유지됩니다.
  """

  def uniq_by([], _fun), do: []

  def uniq_by([h | t], fun) do
    [h] ++ uniq_by(reject(t, fn x -> fun.(x) === fun.(h) end), fun)
  end

  @doc """
    unzip/1 zip/2의 반대 함수로 주어진 튜플에서 2개의 요소를 추출하여 각각 left list와 rigth list에 넣어 반환합니다.
    이 함수는 각 튜플에 대해서 두 개의 요소가 있는 enumerable 튜플 목록으로 변환될 수 없으면 실패합니다.
  """

  def unzip(map) when is_map(map), do: unzip(Enum.to_list(map), [], [])
  def unzip(list), do: unzip(list, [], [])
  defp unzip([], left, right), do: {left, right}

  defp unzip([h | t], left, right) do
    {tuple_left, tuple_right} = h
    unzip(t, left ++ [tuple_left], right ++ [tuple_right])
  end

  @doc """
    with_index/2 각 요소들을 인덱스와 함께 튜플에 래핑된 각 요소를 반환합니다.
    fun_or_offset에 함수 또는 정수 오프셋을 받을 수 있습니다.
    fun_or_offset에 값이 주어지지 않은 경우 default 값으로 0으로 래핑하여 반환합니다.
    fun 이 주어질경우 인덱스는 0으로 시작하여 함수의 호출값으로 래핑하여 반환합니다.
  """

  def with_index(list, fun_or_offset \\ 0)
  def with_index(list, fun_or_offset), do: with_index(list, fun_or_offset, [])
  defp with_index([], _offset, result), do: result

  defp with_index([h | t], offset, result) when is_number(offset),
    do: with_index(t, offset + 1, result ++ [{h, offset}])

  defp with_index(list, fun, result) when is_function(fun), do: with_index(list, fun, result, 0)
  defp with_index([], _fun, result, _offset), do: result

  defp with_index([h | t], fun, result, offset),
    do: with_index(t, fun, result ++ [fun.(h, offset)], offset + 1)
end
