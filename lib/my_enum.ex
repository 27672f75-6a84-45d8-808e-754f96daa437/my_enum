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
end
