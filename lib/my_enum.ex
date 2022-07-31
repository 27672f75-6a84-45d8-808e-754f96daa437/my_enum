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

  def reverse([h | t], tail \\ []), do: reverse(t, [h], tail)
  defp reverse([h | t], arg, tail), do: reverse(t, [h | arg], tail)
  defp reverse([], arg, tail), do: arg ++ tail

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
end
