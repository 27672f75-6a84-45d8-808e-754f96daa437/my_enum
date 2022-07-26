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
end
