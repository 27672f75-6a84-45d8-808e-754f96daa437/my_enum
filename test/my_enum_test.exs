defmodule MyEnumTest do
  use ExUnit.Case
  doctest MyEnum

  describe "MyEnum.all?/1 tests" do
    test "빈 리스트가 들어오면 true를 반환한다." do
      assert MyEnum.all?([])
    end

    test "리스트 요소가 모두 true이면 true를 반환한다." do
      assert MyEnum.all?([true, true, true])
    end

    test "리스트 요소중 false가 하나라도 있다면 false를 반환한다" do
      assert false == MyEnum.all?([1, false, 3])
    end

    test "리스트 요소중 nil이 하나라도 있다면 false를 반환한다" do
      assert false == MyEnum.all?([1, nil, 3])
    end

    test "리스트 요소가 false나 nil이 아니고 argument 매칭이 된다면 true를 반환한다." do
      assert MyEnum.all?([true, true, true])
    end

    test "리스트가 아니면 false를 반환한다." do
      assert false == MyEnum.all?("list")
    end
  end

  describe "MyEnum.all?/2 tests" do
    test "모든 요소가 주어진 함수에 대해서 true일때 true를 반환한다." do
      assert MyEnum.all?([1, 2, 3], fn x -> x > 0 end)
    end

    test "모든 요소중 하나라도 주어진 함수에 대해서 false라면 false를 반환한다." do
      assert false == MyEnum.all?([1, -1, 3], fn x -> x == 0 end)
    end
  end

  describe "MyEnum.any?/1 tests" do
    test "빈 리스트가 들어오면 false를 반환한다." do
      assert false == MyEnum.any?([])
    end

    test "리스트 요소중 하나라도 truthy하면 true를 반환한다." do
      assert MyEnum.any?([false, false, true])
    end

    test "리스트 요소가 모두 false라면 false를 반환한다" do
      assert false == MyEnum.any?([false, false, false])
    end

    test "리스트 요소중 argument 매칭이 되는 요소가 하나라도 있으면 true를 반환한다." do
      assert MyEnum.any?([nil, 1, false])
    end

    test "리스트가 아니면 false를 반환한다." do
      assert false == MyEnum.any?("list")
    end
  end

  describe "MyEnum.any?/2 tests" do
    test "모든 요소가 주어진 함수에 대해서 false일때 false를 반환한다." do
      assert false == MyEnum.any?([1, false, nil], fn x -> x == 0 end)
    end

    test "모든 요소중 하나라도 주어진 함수에 대해서 true라면 true를 반환한다." do
      assert MyEnum.any?([2, 4, 6], &(rem(&1, 2) == 0))
    end
  end

  describe "MyEnum.at/3 tests" do
    test "리스트에서 해당하는 인덱스에 요소가 있는지 확인한다." do
      assert MyEnum.at([1, 2, 3], 1)
    end

    test "리스트에서 해당하는 인덱스에 요소가 있는지 확인한다. 없다면 기본값인 default \\ nil를 반환한다." do
      assert nil == MyEnum.at([1, 2, 3], 4)
    end

    test "리스트에서 해당하는 인덱스에 요소가 있는지 확인한다. 없다면 주어진 default값을 반환한다." do
      assert false == MyEnum.at([1, 2, 3], 4, false)
    end

    test "리스트에서 인덱스가 음수로 주어질때 리스트의 뒤에서부터 차례로 요소가 있는지 확인한다." do
      assert MyEnum.at([1, 2, 3], -2)
    end

    test "리스트에서 인덱스가 음수로 주어질때 리스트의 뒤에서부터 차례로 요소가 있는지 확인한다. 없다면 역시 기본값인 default \\ nil를 반환한다." do
      assert nil == MyEnum.at([1, 2, 3], -4)
    end
  end

  describe "MyEnum.reverse/1 tests" do
    test "주어진 리스트를 반대로 뒤집는다." do
      assert [3, 2, 1] == MyEnum.reverse([1, 2, 3])
    end

    test "주어진 리스트가 비어있다면 []를 반환한다." do
      assert [] == MyEnum.reverse([])
    end
  end

  describe "MyEnum.reverse/2 tests" do
    test "주어진 리스트를 반대로 뒤집고 tail있다면 뒤집은 리스트에 붙여 반환한다." do
      assert [3, 2, 1, 4, 5, 6] == MyEnum.reverse([1, 2, 3], [4, 5, 6])
    end

    test "주어진 리스트가 [] 이고 tail있다면 tail만 반환한다." do
      assert [4, 5, 6] == MyEnum.reverse([], [4, 5, 6])
    end

    test "주어진 리스트가 [] 이고 tail도 []라면 []를 반환한다." do
      assert [] == MyEnum.reverse([], [])
    end
  end

  describe "MyEnum.flatten/1 tests" do
    test "주어진 리스트의 요소의 중첩목록을 없애 평탄화를 한다." do
      assert [1, 2, 3, 4, 5, 6, 7] == MyEnum.flatten([1, [2, 3], [4, [5, 6, [[[[[[[7]]]]]]]]]])
    end
  end

  describe "MyEnum.flatten/2 tests" do
    test "주어진 리스트의 요소의 중첩목록을 없애 평탄화를하고 그 뒤에 제공한 리스트를 붙인다." do
      assert [1, 2, 3, 4, 5, 6, 7, 8, [9], 10] ==
               MyEnum.flatten([1, [2, 3], [4, [5, 6, [[[[[[[7]]]]]]]]]], [8, [9], 10])
    end
  end

  describe "MyEnum.concat/1 tests" do
    test "주어진 리스트의 요소가 열거 가능한 요소일때 하나의 리스트로 요소들을 합친다." do
      assert [1, [2], [3], 4, 5, 6] ==
               MyEnum.concat([[1, [2], [3]], [4], [5, 6]])
    end
  end

  describe "MyEnum.concat/2 tests" do
    test "주어진 리스트의 요소가 열거 가능한 요소일때 하나의 리스트로 요소들을 합치고 제공된 열거가능한 리스트가 있다면 같이 합친다.." do
      assert [1, [2], [3], 4, 5, 6, 7, [8], 9] ==
               MyEnum.concat([[1, [2], [3]], [4], [5, 6]], [7, [8], 9])
    end
  end

  describe "MyEnum.count/1 tests" do
    test "주어진 리스트의 요소 개수를 반환한다." do
      assert MyEnum.count([1, 2, 3])
    end

    test "주어진 리스트가 비어있다면 0 을 반환한다." do
      assert 0 == MyEnum.count([])
    end
  end

  describe "MyEnum.count/2 tests" do
    test "주어진 리스트에서 제공한 함수를 만족하는 요소의 개수를 반환한다." do
      assert MyEnum.count([1, 2, 3], fn x -> x > 2 end)
    end

    test "주어진 리스트가 비어있다면 0 을 반환한다." do
      assert 0 == MyEnum.count([], fn x -> x > 0 end)
    end
  end

  describe "MyEnum.count_until/2 tests" do
    test "제공한 limit 가 0이라면 함수를 실행하지 못한다." do
      limit = 0
      assert 0 == MyEnum.count_until([1, 2, 2, 2, 2, 3], limit, fn x -> x == 2 end)
    end

    test "제공한 리스트가 비어있다면 0을 반환한다." do
      limit = 5
      assert 0 == MyEnum.count_until([], limit)
    end

    test "주어진 리스트의 요소 개수가 적어도 주어진 limit 개수만큼 만족하는지를 확인한다. 확인 도중 이미 주어진 limit 개수를 만족하면 limit 개수를 반환한다." do
      limit = 2
      assert limit == MyEnum.count_until([1, 2, 3, 4, 5], limit)
    end

    test "주어진 리스트의 요소 개수가 적어도 주어진 limit 개수만큼 만족하는지를 확인한다. 만족하지 못하면 리스트 요소의 개수를 반환한다." do
      limit = 6
      list = [1, 2, 3]
      assert Enum.count(list) == MyEnum.count_until(list, limit)
    end
  end

  describe "MyEnum.count_until/3 tests" do
    test "제공한 limit 가 0이라면 함수를 실행하지 못한다." do
      limit = 0
      assert 0 == MyEnum.count_until([1, 2, 2, 2, 2, 3], limit, fn x -> x == 2 end)
    end

    test "제공한 리스트가 비어있다면 0을 반환한다." do
      limit = 20
      assert 0 == MyEnum.count_until([], limit, fn x -> x == 2 end)
    end

    test "제공한 함수를 만족하는 요소의 개수가 주어진 limit 개수만큼 만족하는지를 확인한다. 확인 도중 이미 주어진 limit 개수를 만족하면 limit 개수를 반환한다." do
      limit = 2
      assert 2 == MyEnum.count_until([1, 2, 2, 2, 2, 3], limit, fn x -> x == 2 end)
    end

    test "제공한 함수를 만족하는 요소의 개수가 주어진 limit 개수만큼 만족하는지를 확인한다. 만족하지 못하면 리스트 요소의 개수를 반환한다." do
      limit = 50
      assert 4 == MyEnum.count_until([1, 2, 2, 2, 2, 3], limit, fn x -> x == 2 end)
    end
  end

  describe "MyEnum.dedup/1 tests" do
    test "제공한 리스트가 비어있다면 []을 반환한다." do
      assert [] == MyEnum.dedup([])
    end

    test "리스트에서 나열된 요소중 중복된 요소를 나열되지 않게 하나로 만든다." do
      assert [1, 2, 3, 2, 1] == MyEnum.dedup([1, 2, 3, 3, 2, 1])
    end

    test "리스트에서 나열된 요소중 중복된 요소를 나열되지 않게 하나로 만든다. 모든 타입 가능" do
      assert [1, 2, 2.0, :three] == MyEnum.dedup([1, 1, 2, 2.0, :three, :three])
    end
  end

  describe "MyEnum.dedup_by/2 tests" do
    test "제공한 리스트가 비어있다면 []을 반환한다." do
      assert [] == MyEnum.dedup_by([], fn _ -> true end)
    end

    test "리스트에서 주어진 함수를 거쳐 나열된 요소 중 중복되는 요소를 하나로 만듬." do
      assert [{1, :a}, {2, :b}, {1, :a}] ==
               MyEnum.dedup_by([{1, :a}, {2, :b}, {2, :c}, {1, :a}], fn {x, _} -> x end)
    end

    test "리스트에서 주어진 함수를 거쳐  나열된 요소 중 중복되는 요소를 하나로 만듬2." do
      assert [5, 1, 3, 2] == MyEnum.dedup_by([5, 1, 2, 3, 2, 1], fn x -> x > 2 end)
    end
  end

  describe "MyEnum.drop/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.drop([], 30)
    end

    test "주어진 amount 만큼 리스트의 요소를 삭제해 나갑니다." do
      assert [4, 5] == MyEnum.drop([1, 2, 3, 4, 5], 3)
    end

    test "주어진 리스트의 크기보다 amount가 크다면 []를 반환합니다." do
      assert [] == MyEnum.drop([1, 2, 3, 4, 5], 10)
    end

    test "주어진 amount가 음수라면 뒤에서 amount 만큼 리스트의 요소를 삭제해 나갑니다." do
      assert [1, 2, 3] == MyEnum.drop([1, 2, 3, 4, 5], -2)
    end

    test "주어진 amount가 음수이면서 리스트의 크기보다 amount의 절대값이 크면 []를 반환합니다." do
      assert [] == MyEnum.drop([1, 2, 3, 4, 5], -30)
    end
  end

  describe "MyEnum.drop_every/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.drop_every([], 30)
    end

    test "주어진 nth는 음수값이 될 수 없습니다. 임시로 []를 반환합니다." do
      assert [] == MyEnum.drop_every([1, 2, 3, 4, 5], -3)
    end

    test "주어진 nth의 간격으로 리스트의 요소를 제거해 나갑니다." do
      assert [2, 4, 6, 8, 10] == MyEnum.drop_every([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2)
    end

    test "주어진 nth가 0이라면 리스트를 그대로 반환합니다." do
      assert [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] ==
               MyEnum.drop_every([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 0)
    end

    test "주어진 nth가 1이라면 간격이 1이라 요소가 모두 삭제되므로 []를 반환합니다." do
      assert [] == MyEnum.drop_every([1, 2, 3, 4, 5], 1)
    end
  end

  describe "MyEnum.drop_while/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.drop_while([], fn x -> x == 0 end)
    end

    test "함수를 만족하는 요소를 모두 제거합니다." do
      assert [] == MyEnum.drop_while([1, 2, 3, 4, 5], fn x -> x > 0 end)
    end

    test "함수를 만족하는 요소를 모두 제거합니다. 2" do
      assert [1, 3, 5] == MyEnum.drop_while([1, 2, 3, 4, 5], fn x -> rem(x, 2) == 0 end)
    end

    test "함수를 만족하지 못하는 요소는 제거되지 않습니다." do
      assert [1, 2, 3, 4, 5] == MyEnum.drop_while([1, 2, 3, 4, 5], fn _ -> false end)
    end
  end

  describe "MyEnum.each/2 tests" do
    test "제공한 리스트가 비어있다면 :ok을 반환한다." do
      assert :ok == MyEnum.each([], fn x -> rem(x, 2) == 0 end)
    end

    test "요소를 순회하며 주어진 함수에 요소값을 넣어 실행한다. 모두 순회하면 :ok를 반환한다." do
      assert :ok == MyEnum.each([1, 2, 3, 3, 2, 1], fn x -> x - 1 == 0 end)
    end

    test "함수의 결과에는 영향을 받지않고 모든 요소를 순회하면 :ok를 반환한다." do
      assert :ok == MyEnum.each([1, 2, 3, 4, 5], fn _ -> false end)
    end
  end

  describe "MyEnum.empty?/1 tests" do
    test "제공한 리스트가 비어있다면 true를 반환한다." do
      assert true == MyEnum.empty?([])
    end

    test "제공한 리스트가 비어있지 않다면 false를 반환한다." do
      assert false == MyEnum.empty?([1, 2, 3])
    end
  end

  describe "MyEnum.fetch!/2 tests" do
    test "리스트에서 해당하는 인덱스의 요소를 찾으면 요소를 반환한다." do
      assert 1 == MyEnum.fetch!([1, 2, 3], 0)
    end

    test "인덱스를 음수로 넣으면 요소의 뒤에서 부터 fetch!/2 수행한다." do
      assert 3 == MyEnum.fetch!([1, 2, 3], -1)
    end
  end

  describe "MyEnum.fetch/2 tests" do
    test "제공한 리스트가 비어있다면 :error를 반환한다." do
      assert :error == MyEnum.fetch([], 2)
    end

    test "리스트에서 해당하는 인덱스의 요소를 찾지못하여 범위를 벗어나면 :error를 반환한다." do
      assert :error == MyEnum.fetch([1, 2, 3], 4)
    end

    test "리스트에서 해당하는 인덱스의 요소를 찾으면 {:ok, _arg}를 반환한다." do
      assert {:ok, 1} == MyEnum.fetch([1, 2, 3], 0)
    end

    test "인덱스를 음수로 넣으면 요소의 뒤에서 부터 fetch/2 수행한다." do
      assert {:ok, 3} == MyEnum.fetch([1, 2, 3], -1)
    end

    test "인덱스를 음수로 넣을때 역시 리스트의 범위를 벗어나면 :error를 반환한다." do
      assert :error == MyEnum.fetch([1, 2, 3], -5)
    end
  end

  describe "MyEnum.filter/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환한다." do
      assert [] == MyEnum.filter([], fn x -> x > 2 end)
    end

    test "리스트에서 함수에 요소를 넣어 만족하는 요소들만 결과로 반환한다." do
      assert [2, 3] == MyEnum.filter([1, 2, 3], fn x -> x > 1 end)
    end

    test "리스트에서 함수에 만족하는 요소가 없으면 []를 반환한다." do
      assert [] == MyEnum.filter([1, 2, 3], fn x -> x < 0 end)
    end
  end

  describe "MyEnum.find/3 tests" do
    test "제공한 리스트가 비어있다면 default \\ nil를 반환한다." do
      assert nil == MyEnum.find([], fn x -> x == 2 end)
    end

    test "리스트에서 함수에 만족하는 첫번째 요소를 반환한다." do
      assert 2 == MyEnum.find([1, 2, 3], fn x -> x == 2 end)
    end

    test "리스트에서 함수에 만족하는 요소가 없을 때 default값이 제공됐다면 default값을 반환한다." do
      assert "can't find" == MyEnum.find([1, 2, 3], "can't find", fn x -> x < 0 end)
    end
  end

  describe "MyEnum.find_index/2 tests" do
    test "제공한 리스트가 비어있다면 nil를 반환한다." do
      assert nil == MyEnum.find_index([], fn x -> x == 2 end)
    end

    test "리스트에서 함수에 만족하는 첫번째 요소의 인덱스를 반환한다." do
      assert 1 == MyEnum.find_index([1, 2, 3], fn x -> x == 2 end)
    end

    test "리스트에서 함수에 만족하는 요소가 없으면 nil을 반환한다." do
      assert nil == MyEnum.find_index([1, 2, 3], fn x -> x < 0 end)
    end
  end

  describe "MyEnum.find_value/3 tests" do
    test "제공한 리스트가 비어있다면 default \\ nil를 반환한다." do
      assert nil == MyEnum.find_value([], fn x -> x == 2 end)
    end

    test "리스트에서 함수에 만족하는 첫번째 요소의 함수 호출 값을 반환한다." do
      assert 9 == MyEnum.find_value([1, 2, 3], fn x -> if x > 2, do: x * x end)
    end

    test "리스트에서 함수에 만족하는 첫번째 요소의 함수 호출 값을 반환한다. 2" do
      assert true == MyEnum.find_value([2, 3, 4], fn x -> rem(x, 2) == 1 end)
    end

    test "리스트에서 함수에 만족하는 첫번째 요소가 없다면 default 값을 반환한다." do
      assert nil == MyEnum.find_value([2, 3, 4], fn x -> x < 0 end)
    end

    test "리스트에서 함수에 만족하는 요소가 없고 default값이 제공되어 있다면 default를 반환한다." do
      assert "no bools!" == MyEnum.find_value([1, 2, 3], "no bools!", &is_boolean/1)
    end
  end

  describe "MyEnum.flat_map/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환한다." do
      assert [] == MyEnum.flat_map([], fn x -> [[x]] end)
    end

    test "함수를 적용하여 나온 결과를 매핑하고 하나의 리스트로 합친다. 함수 반환결과는 열거 가능형식의 요소다." do
      assert [[1], [2], [3]] == MyEnum.flat_map([1, 2, 3], fn x -> [[x]] end)
    end

    test "함수를 적용하여 나온 결과를 매핑하고 하나의 리스트로 합친다. 함수 반환결과는 열거 가능형식의 요소다.2" do
      assert [:a, :a, :b, :b, :c, :c] == MyEnum.flat_map([:a, :b, :c], fn x -> [x, x] end)
    end
  end

  describe "MyEnum.flat_map_reduce/3 tests" do
    test "제공한 리스트가 비어있다면 {[], acc} 를 반환한다." do
      acc = 5
      assert {[], acc} == MyEnum.flat_map_reduce([], acc, fn x, acc -> {[x], acc + 1} end)
    end

    test "요소에 함수를 적용하여 나온 결과를 매핑하고 한단계 평탄화를 하고 누산된 결과를 반환한다." do
      acc = 0

      assert {[1, 2, 3], 3} ==
               MyEnum.flat_map_reduce([1, 2, 3, 4, 5], acc, fn x, acc ->
                 if acc < 3, do: {[x], acc + 1}, else: {:halt, acc}
               end)
    end

    test "요소에 함수를 적용하여 나온 결과를 매핑하고 한단계 평탄화를 하고 누산된 결과를 반환한다.2" do
      acc = 0

      assert {[[1], [2], [3], [4], [5]], 15} ==
               MyEnum.flat_map_reduce([1, 2, 3, 4, 5], acc, fn x, acc -> {[[x]], acc + x} end)
    end
  end

  describe "MyEnum.frequencies/1 tests" do
    test "제공한 리스트가 비어있다면 %{} 를 반환한다." do
      assert %{} == MyEnum.frequencies([])
    end

    test "요소가 리스트내에서 얼마나 반복되는지를 맵으로 반환한다." do
      assert %{1 => 1, 2 => 1, 3 => 2, 4 => 1, 5 => 2, 6 => 1, 67 => 1} ==
               MyEnum.frequencies([1, 2, 3, 3, 4, 5, 5, 6, 67])
    end

    test "요소가 리스트내에서 얼마나 반복되는지를 맵으로 반환한다.2" do
      assert %{:a => 3, :b => 3, :c => 2} ==
               MyEnum.frequencies([:a, :a, :b, :a, :b, :c, :c, :b])
    end

    test "요소가 리스트내에서 얼마나 반복되는지를 맵으로 반환한다.3" do
      assert %{"one" => 3, "two" => 2, "three" => 2, "four" => 1} ==
               MyEnum.frequencies(["one", "one", "three", "two", "two", "one", "three", "four"])
    end
  end

  describe "MyEnum.frequencies_by/2 tests" do
    test "제공한 리스트가 비어있다면 %{} 를 반환한다." do
      assert %{} == MyEnum.frequencies_by([], fn x -> x end)
    end

    test "함수에 요소를 적용하여 나온 결과가 리스트내에서 얼마나 반복되는지를 맵으로 반환한다." do
      assert %{0 => 7, 1 => 3} ==
               MyEnum.frequencies_by([1, 2, 2, 3, 3, 4, 4, 2, 2, 4], fn x -> rem(x, 2) end)
    end

    test "함수에 요소를 적용하여 나온 결과가 리스트내에서 얼마나 반복되는지를 맵으로 반환한다.2" do
      assert %{3 => 5, 4 => 1, 5 => 1} ==
               MyEnum.frequencies_by(
                 ["one", "one", "two", "one", "three", "four", "one"],
                 &String.length/1
               )
    end
  end

  describe "MyEnum.group_by/3 tests" do
    test "제공한 리스트가 비어있다면 %{} 를 반환한다." do
      assert %{} == MyEnum.group_by([], fn x -> x end)
    end

    test "key_function에 요소를 적용하여 얻은 Key 결과가 같은 요소끼리 그룹화 하여 반환합니다. " do
      assert %{3 => ["asd", "one"], 4 => ["four"], 5 => ["three"]} ==
               MyEnum.group_by(["asd", "one", "three", "four"], &String.length/1)
    end

    test "key_function에 요소를 적용하여 얻은 Key 결과가 같은 요소끼리 그룹화 하여 반환합니다.2 " do
      assert %{0 => [2, 2, 4, 4, 6, 8], 1 => [1, 3, 5, 7, 7, 9]} ==
               MyEnum.group_by([1, 2, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9], fn x -> rem(x, 2) end)
    end

    test "key_function에 요소를 적용하여 얻은 Key 결과가 같은 요소를 value_function을 적용하여 반환합니다. " do
      assert %{3 => ["a", "o"], 4 => ["f"], 5 => ["t"]} ==
               MyEnum.group_by(["asd", "one", "three", "four"], &String.length/1, &String.first/1)
    end

    test "key_function에 요소를 적용하여 얻은 Key 결과가 같은 요소를 value_function을 적용하여 반환합니다.2 " do
      assert %{0 => [4, 4, 16, 16, 36, 64], 1 => [1, 9, 25, 49, 49, 81]} ==
               MyEnum.group_by(
                 [1, 2, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9],
                 fn x -> rem(x, 2) end,
                 fn x -> x * x end
               )
    end
  end

  describe "MyEnum.intersperse/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.intersperse([], 0)
    end

    test "제공한 리스트의 요소가 하나라면 리스트를 바로 반환합니다." do
      assert [1] == MyEnum.intersperse([1], 0)
    end

    test "제공한 리스트의 요소 사이에 구분자를 넣습니다." do
      assert [1, 0, 2, 0, 3, 0, 4, 0, 5] == MyEnum.intersperse([1, 2, 3, 4, 5], 0)
    end

    test "제공한 리스트의 요소 사이에 구분자를 넣습니다.2" do
      assert [1, "seperator", 2, "seperator", 3, "seperator", 4, "seperator", 5] ==
               MyEnum.intersperse([1, 2, 3, 4, 5], "seperator")
    end
  end

  describe "MyEnum.into/3 tests" do
    test "제공한 리스트가 비어있다면 colletable을 반환합니다." do
      colletable = %{a: 1, b: 2, c: 3}
      assert colletable == MyEnum.into([], colletable)
    end

    test "list가 제공되고 colletable이 list일때 colletable에 리스트 요소를 넣어 반환합니다." do
      colletable = [4, 5, 6]
      assert [4, 5, 6, 1, 2, 3] == MyEnum.into([1, 2, 3], colletable)
    end

    test "keyword list가 제공되고 colletable이 map일때 colletable에 리스트 요소를 넣어 반환합니다." do
      colletable = %{a: 5}
      assert %{a: 1, b: 2, c: 3} == MyEnum.into([a: 1, b: 2, c: 3], colletable)
    end

    test "map이 제공되고 colletable이 list일때 colletable에 map 요소를 넣어 반환합니다." do
      assert [{0, [1, 2, 3]}, {:a, 1}] == MyEnum.into(%{0 => [1, 2, 3], a: 1}, [])
    end

    test "map이 제공되고 colletable이 map일때 colletable에 map 요소를 넣어 반환합니다." do
      assert %{0 => [1, 2, 3], :a => 1, :b => 2} ==
               MyEnum.into(%{0 => [1, 2, 3], a: 1}, %{0 => [1], a: 4, b: 2})
    end
  end

  describe "MyEnum.join/2 tests" do
    test "빈 리스트가 주어지면 빈 문자열을 반환합니다" do
      assert "" == MyEnum.join([], "is_empty")
    end

    test "리스트만 주어지면 하나의 문자열로 반환합니다." do
      assert "123" == MyEnum.join([1, 2, 3])
    end

    test "리스트와 joiner가 주어지면 joiner를 구분자로 하여 하나의 문자열을 반환합니다." do
      assert "1 / 2 / 3" == MyEnum.join([1, 2, 3], " / ")
    end
  end

  describe "MyEnum.map/2 tests" do
    test "빈 리스트가 주어지면 빈 리스트를 반환합니다" do
      assert [] == MyEnum.map([], fn x -> x end)
    end

    test "리스트의 모든 요소에 함수를 적용하여 리스트 형식으로 반환합니다." do
      assert [-1, -2, -3] == MyEnum.map([1, 2, 3], fn x -> -x end)
    end

    test "키워드 리스트의 모든 요소에 함수를 적용하여 리스트 형식으로 반환합니다." do
      assert [a: 2, b: 4, c: 6] == MyEnum.map([a: 1, b: 2, c: 3], fn {k, v} -> {k, v * 2} end)
    end

    test "맵의 모든 요소에 함수를 적용하여 리스트 형식으로 반환합니다." do
      assert [a: 0, b: 1, c: 2] == MyEnum.map(%{a: 1, b: 2, c: 3}, fn {k, v} -> {k, v - 1} end)
    end
  end

  describe "MyEnum.map_every/3 tests" do
    test "빈 리스트가 주어지면 빈 리스트를 반환합니다." do
      assert [] == MyEnum.map_every([], 2, fn x -> x end)
    end

    test "주어진 요소를 nth 간격으로 함수를 적용하여 바뀐 요소들의 리스트를 반환합니다." do
      assert [-1, 2, -3, 4, -5, 6, -7, 8, -9, 10] ==
               MyEnum.map_every([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2, fn x -> -x end)
    end

    test "주어진 키워드 리스트 요소를 nth 간격으로 함수를 적용하여 바뀐 요소들의 리스트를 반환합니다." do
      assert [a: -1, b: 2, c: -3, d: 4, e: -5, f: 6, g: -7] ==
               MyEnum.map_every([a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7], 2, fn {k, v} ->
                 {k, -v}
               end)
    end

    test "주어진 간격이 1이라면 모든 요소에 함수를 적용하여 리스트를 반환합니다." do
      assert [-1, -2, -3, -4, -5, -6, -7, -8, -9, -10] ==
               MyEnum.map_every([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 1, fn x -> -x end)
    end

    test "주어진 간격이 0이라면 주어진 리스트를 그대로 반환합니다." do
      assert [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] ==
               MyEnum.map_every([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 0, fn x -> -x end)
    end

    test "map이 주어질 경우 모든 요소에 함수를 적용하여 리스트로 키워드 리스트로 반환합니다." do
      assert [a: -1, b: 2, c: -3, d: 4, e: -5, f: 6] ==
               MyEnum.map_every(%{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}, 2, fn {k, v} -> {k, -v} end)
    end
  end

  describe "MyEnum.map_intersperse/3 tests" do
    test "빈 리스트가 주어지면 빈 리스트를 반환합니다" do
      assert [] == MyEnum.map_intersperse([], :a, fn x -> -x end)
    end

    test "요소가 하나라면 구분자를 넣지않고 함수만 적용하여 반환합니다." do
      assert [-1] == MyEnum.map_intersperse([1], :a, fn x -> -x end)
    end

    test "요소에 함수를 적용하고 각 요소 사이 구분자를 넣어 리스트를 반환합니다." do
      assert [-1, :a, -2, :a, -3, :a, -4, :a, -5] ==
               MyEnum.map_intersperse([1, 2, 3, 4, 5], :a, &(-&1))
    end
  end

  describe "MyEnum.map_join/3 tests" do
    test "빈 리스트가 주어지면 빈 문자열을 반환합니다" do
      assert "" == MyEnum.map_join([], " = ", fn x -> -x end)
    end

    test "요소 사이에 joiner 값을 넣는데 주어지지 않으면 default 값인 빈문자열을 넣고 요소에 함수를 적용하여 하나의 문자열로 만듭니다." do
      assert "-1-2-3-4-5" == MyEnum.map_join([1, 2, 3, 4, 5], "", fn x -> -x end)
    end

    test "요소 사이에 joiner 값을 넣고 요소에 함수를 적용하여 하나의 문자열로 만듭니다." do
      assert "-1 = -2 = -3 = -4 = -5" == MyEnum.map_join([1, 2, 3, 4, 5], " = ", fn x -> -x end)
    end
  end

  describe "MyEnum.map_reduce/3 tests" do
    test "빈 리스트가 주어지면 {[], acc} 가 반환됩니다." do
      acc = 3
      assert {[], 3} == MyEnum.map_reduce([], acc, fn x, acc -> {[x], acc + 1} end)
    end

    test "모든 요소에 매핑함수를 적용하여 나온 결과와 누산된 결과를 반환합니다." do
      assert {[[2], [4], [6], '\b', '\n'], 5} ==
               MyEnum.map_reduce([1, 2, 3, 4, 5], 0, fn x, acc -> {[x * 2], acc + 1} end)
    end

    test "모든 요소에 매핑함수를 적용하여 나온 결과와 누산된 결과를 반환합니다. 2" do
      assert {[2, 4, 6, 8, 10], 15} ==
               MyEnum.map_reduce([1, 2, 3, 4, 5], 0, fn x, acc -> {x * 2, x + acc} end)
    end
  end

  describe "MyEnum.max/3 tests" do
    test "빈 리스트가 주어지면 empty_fallback를 반환합니다." do
      assert 0 == MyEnum.max([], &>=/2, fn -> 0 end)
    end

    test "Erlang의 용어 순서에 따라 가장 큰 값을 산출합니다. " do
      assert "7" == MyEnum.max([1, :b, {3}, %{d: 5}, [6], "7"])
    end

    test "모든 요소의 값이 같다면 첫번째로 가장 큰 요소를 반환합니다." do
      assert 1 == MyEnum.max([1, 1, 1, 1, 1, 1, 1, 1, 1])
    end

    test "주어진 비교 함수를 통해서 가장 큰 요소를 구합니다." do
      assert ~D[2017-04-01] == MyEnum.max([~D[2017-03-31], ~D[2017-04-01]], Date)
    end
  end

  describe "MyEnum.max_by/4 tests" do
    test "빈 리스트가 주어지면 empty_fallback를 반환합니다." do
      assert 0 == MyEnum.max_by([], fn x -> -x end, &>=/2, fn -> 0 end)
    end

    test "주어진 요소에 함수를 적용하여 가장 큰 요소를 반환합니다." do
      assert 1 == MyEnum.max_by([1, 2, 3, 4, 5, 6, 7], fn x -> -x end)
    end

    test "모두가 같은 요소일때 주어진 sort가 모든 요소에 대해서 true 이면 가장 마지막 요소를 반환한다." do
      assert "eee" ==
               MyEnum.max_by(
                 ["abc", "aaa", "cba", "dac", "sss", "fff", "eee"],
                 fn x -> String.length(x) end
               )
    end

    test "모두가 같은 요소일때 주어진 sort가 모든 요소에 대해서 true를 반환하지 않으면 가장 첫번째 요소를 반환합니다." do
      assert "abc" ==
               MyEnum.max_by(
                 ["abc", "aaa", "cba", "dac", "sss", "fff", "eee"],
                 fn x -> String.length(x) end,
                 &>/2
               )
    end
  end

  describe "MyEnum.member?/2 tests" do
    test "빈 리스트가 주어지면 false를 반환합니다." do
      assert false == MyEnum.member?([], 1)
    end

    test "리스트를 순회하며 element를 찾고 존재하면 true를 반환합니다." do
      assert true == MyEnum.member?([1, 2, 3, 4, 5], 5)
    end

    test "리스트를 순회하며 element를 찾고 존재하지 않으면 false를 반환합니다." do
      assert false == MyEnum.member?([1, 2, 3, 4, 5], 1.0)
    end
  end

  describe "MyEnum.min/3 tests" do
    test "빈 리스트가 주어지면 empty_fallback을 반환합니다." do
      assert 0 == MyEnum.min([], &<=/2, fn -> 0 end)
    end

    test "주어진 요소중에서 가장 작은 값을 반환합니다." do
      assert 1 == MyEnum.min([2, 5, 6, 1, 4, 3])
    end

    test "주어진 요소중에서 가장 작은 값을 반환합니다. sorter에 구조체를 넣으면 구조체 비교 함수를 통해 비교합니다." do
      assert ~D[2022-04-11] == MyEnum.min([~D[2022-04-11], ~D[2023-02-07]], Date)
    end
  end

  describe "MyEnum.min_by/4 tests" do
    test "빈 리스트가 주어지면 empty_fallback를 반환합니다." do
      assert 0 == MyEnum.min_by([], fn x -> -x end, &>=/2, fn -> 0 end)
    end

    test "주어진 요소에 함수를 적용하여 가장 작은 요소를 반환합니다." do
      assert 7 == MyEnum.min_by([1, 2, 3, 4, 5, 6, 7], fn x -> -x end)
    end

    test "모두가 같은 요소일때 주어진 sort가 모든 요소에 대해서 true 이면 가장 마지막 요소를 반환한다." do
      assert "eee" ==
               MyEnum.min_by(
                 ["abc", "aaa", "cba", "dac", "sss", "fff", "eee"],
                 fn x -> String.length(x) end
               )
    end

    test "모두가 같은 요소일때 주어진 sort가 모든 요소에 대해서 true를 반환하지 않으면 가장 첫번째 요소를 반환합니다." do
      assert "abc" ==
               MyEnum.min_by(
                 ["abc", "aaa", "cba", "dac", "sss", "fff", "eee"],
                 fn x -> String.length(x) end,
                 &>/2
               )
    end
  end

  describe "MyEnum.min_max/2 tests" do
    test "빈 리스트가 주어지면 empty_fallback를 반환합니다." do
      assert {nil, nil} == MyEnum.min_max([], fn -> {nil, nil} end)
    end

    test "요소에서 가장 작은 값과 큰 값을 튜플로 반환합니다." do
      assert {1, 10} == MyEnum.min_max([4, 3, 5, 7, 8, 1, 9, 10, 6])
    end

    test "요소에서 가장 작은 값과 큰 값을 튜플로 반환합니다. Erlang의 용어 순서에 따라 산출합니다." do
      assert {1, [1]} == MyEnum.min_max([4, 3, 5, :a, 1, 9, 10, [1]])
    end

    test "요소가 모두 같다면 발견된 첫 번째 요소가 반환됩니다." do
      assert {1, 1} == MyEnum.min_max([1, 1, 1, 1, 1, 1, 1, 1, 1])
    end
  end

  describe "MyEnum.min_max_by/4 tests" do
    test "sorter가 empty_fallback으로 제공되었을때 빈 리스트가 주어졌다면 sorter를 반환합니다" do
      assert {nil, nil} == MyEnum.min_max_by([], fn x -> x end, fn -> {nil, nil} end)
    end

    test "빈 리스트가 주어지면 empty_fallback을 반환합니다." do
      assert {nil, nil} == MyEnum.min_max_by([], fn x -> x end, &>=/2, fn -> {nil, nil} end)
    end

    test "주어진 함수에 의해 계산된 요소중에서 최소값과 최대값을 튜플로 반환합니다." do
      assert {5, 1} == MyEnum.min_max_by([1, 2, 3, 4, 5], fn x -> -x end)
    end

    test "여러 요소가 최대 또는 최소로 간주되는 경우 발견된 첫 번째 요소를 반환합니다." do
      assert {"aaa", "aaa"} ==
               MyEnum.min_max_by(["aaa", "bbb", "ccc", "ddd", "eee"], &String.length/1)
    end

    test "Sorter로 구조체가 전달될 경우 구조체내의 Compare 함수를 사용하여 요소의 최소값과 최대값을 튜플로 반환합니다." do
      assert {%{birthday: ~D[1815-12-10], name: "Tinker"},
              %{birthday: ~D[1943-05-11], name: "Ellis"}} ==
               MyEnum.min_max_by(
                 [
                   %{name: "Ellis", birthday: ~D[1943-05-11]},
                   %{name: "Tinker", birthday: ~D[1815-12-10]},
                   %{name: "Peter", birthday: ~D[1912-06-23]}
                 ],
                 & &1.birthday,
                 Date
               )
    end
  end

  describe "MyEnum.product/1 tests" do
    test "제공한 리스트가 비어있다면 1를 반환합니다." do
      assert 1 == MyEnum.product([])
    end

    test "모든 요소를 곱해 반환합니다." do
      assert 24 == MyEnum.product([2, 3, 4])
    end

    test "모든 요소를 곱해 반환합니다.2" do
      assert 24.0 == MyEnum.product([2.0, 3.0, 4.0])
    end

    test "모든 요소를 곱해 반환합니다.3" do
      assert 0 == MyEnum.product([2, 3, 4, 0])
    end
  end

  describe "MyEnum.reduce/3 tests" do
    test "제공한 리스트가 비어있다면 acc를 반환합니다." do
      acc = 1
      assert acc == MyEnum.reduce([], acc, fn x, acc -> x + acc end)
    end

    test "모든 요소에 함수를 적용하여 누산된 결과를 반환합니다." do
      assert -10 == MyEnum.reduce([1, 2, 3, 4], 0, fn x, acc -> -x + acc end)
    end

    test "모든 요소에 함수를 적용하여 누산된 결과를 반환합니다. 2" do
      assert 6 == MyEnum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)
    end
  end

  describe "MyEnum.reduce_while/3 tests" do
    test "제공한 리스트가 비어있다면 acc를 반환합니다." do
      acc = 5
      assert acc == MyEnum.reduce_while([], acc, fn x, acc -> x + acc end)
    end

    test "함수의 결과로 {:cont, acc} 만 반환된다면 모든 요소를 순회하여 누산된 결과를 반환합니다." do
      assert 15 ==
               MyEnum.reduce_while([1, 2, 3, 4, 5], 0, fn x, acc ->
                 if x > 0, do: {:cont, acc + x}, else: {:halt, acc}
               end)
    end

    test "함수의 결과로 도중에 {:halt, acc} 가 반환된다면 그 즉시 acc를 반환합니다." do
      assert 3 ==
               MyEnum.reduce_while([1, 2, 3, 4, 5], 0, fn x, acc ->
                 if x < 3, do: {:cont, acc + x}, else: {:halt, acc}
               end)
    end
  end

  describe "MyEnum.reject/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.reject([], fn x -> x > 3 end)
    end

    test "함수의 결과로 false 값을 반환하는 요소들만 리스트로 반환합니다." do
      assert [1, 2, 3] == MyEnum.reject([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], fn x -> x > 3 end)
    end

    test "함수의 결과로 false 값을 반환하는 요소들만 리스트로 반환합니다. 2" do
      assert ["aa", "bb", "c"] ==
               MyEnum.reject(["aa", "bb", "c", "dddd", "eeee", "ffff"], fn x ->
                 String.length(x) > 3
               end)
    end
  end

  describe "MyEnum.reverse_slice/3 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.reverse_slice([], 2, 2)
    end

    test "count가 0이라면 리스트를 그대로 반환합니다." do
      assert [1, 2, 3, 4, 5, 6, 7] == MyEnum.reverse_slice([1, 2, 3, 4, 5, 6, 7], 2, 0)
    end

    test "count가 리스트 요소 개수보다 크고 start_index가 주어지면 해당 index 부터 모든 요소를 뒤집어 반환합니다." do
      assert [7, 6, 5, 4, 3, 2, 1] == MyEnum.reverse_slice([1, 2, 3, 4, 5, 6, 7], 0, 100)
    end

    test "start_index 부터 count 만큼 요소를 뒤집어 반환합니다." do
      assert [1, 2, 4, 3, 5, 6, 7] == MyEnum.reverse_slice([1, 2, 3, 4, 5, 6, 7], 2, 2)
    end

    test "start_index 부터 count 만큼 요소를 뒤집어 반환합니다.2" do
      assert [1, 2, 3, 6, 5, 4, 7] == MyEnum.reverse_slice([1, 2, 3, 4, 5, 6, 7], 3, 3)
    end

    test "start_index 부터 count 만큼 요소를 뒤집어 반환합니다.3" do
      assert [1, 2, 6, 5, 4, 3, 7] == MyEnum.reverse_slice([1, 2, 3, 4, 5, 6, 7], 2, 4)
    end

    test "start_index 부터 count 만큼 요소를 뒤집어 반환합니다.4" do
      assert [1, 2, 3, 4, 5, 6, 7] == MyEnum.reverse_slice([1, 2, 3, 4, 5, 6, 7], 100, 100)
    end
  end

  describe "MyEnum.scan/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.scan([], &(&1 + &2))
    end

    test "주어진 함수를 적용한 요소의 결과를 저장하고 다음 계산을 위한 누산기로 사용합니다." do
      assert [1, 3, 6, 10, 15] == MyEnum.scan([1, 2, 3, 4, 5], &(&1 + &2))
    end

    test "주어진 함수를 적용한 요소의 결과를 저장하고 다음 계산을 위한 누산기로 사용합니다.2" do
      assert [0, 0, 0, 0, 0] == MyEnum.scan([0, 2, 3, 4, 5], &(&1 * &2))
    end

    test "주어진 함수를 적용한 요소의 결과를 저장하고 다음 계산을 위한 누산기로 사용합니다.3" do
      assert [1, 2, 6, 24, 120] == MyEnum.scan([1, 2, 3, 4, 5], &(&1 * &2))
    end
  end

  describe "MyEnum.scan/3 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.scan([], 1, &(&1 + &2))
    end

    test "주어진 함수를 적용한 요소의 결과를 저장하고 제공한 acc 값을 누산기로 사용합니다." do
      assert [1, 3, 6, 10, 15] == MyEnum.scan([1, 2, 3, 4, 5], 0, &(&1 + &2))
    end

    test "주어진 함수를 적용한 요소의 결과를 저장하고 제공한 acc 값을 누산기로 사용합니다.2" do
      assert [0, 0, 0, 0, 0] == MyEnum.scan([1, 2, 3, 4, 5], 0, &(&1 * &2))
    end

    test "주어진 함수를 적용한 요소의 결과를 저장하고 제공한 acc 값을 누산기로 사용합니다.3" do
      assert [0, 2, 1, 3, 2] == MyEnum.scan([1, 2, 3, 4, 5], 1, &(&1 - &2))
    end
  end

  describe "MyEnum.slice/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.slice([], 1..2)
    end

    test "제공한 리스트에서 index_range만큼 요소를 잘라내어 반환합니다." do
      assert [2, 3, 4, 5, 6] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 1..5)
    end

    test "제공한 리스트에서 index_range만큼 요소를 잘라내어 반환합니다. index_range.last가 요소보다 크면 최대한 잘라냅니다." do
      assert [2, 3, 4, 5, 6, 7, 8, 9, 10] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 1..100)
    end

    test "제공한 리스트에서 index_range.first가 요소의 범위를 벗어나면 []를 반환합니다." do
      assert [] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 100..1)
    end

    test "제공한 리스트에서 index_range.first가 음수일 때 요소의 뒷부분부터 잘라냅니다." do
      assert '\a\b\t' == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -4..-2)
    end

    test "제공한 리스트에서 index_range.first가 음수일 때 요소의 뒷부분부터 잘라냅니다.2" do
      assert [2, 3] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -9..-8)
    end
  end

  describe "MyEnum.slice/3 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.slice([], 2, 3)
    end

    test "제공한 리스트에서 start_index부터 시작하여 amount 만큼 잘라냅니다." do
      assert [2, 3, 4, 5, 6] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 1, 5)
    end

    test "제공한 리스트에서 start_index부터 시작하여 amount 만큼 잘라냅니다. amount가 요소 범위보다 크면 최대한 잘라냅니다." do
      assert [2, 3, 4, 5, 6, 7, 8, 9, 10] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 1, 100)
    end

    test "제공한 start_index가 요소의 범위를 벗어나면 []를 반환합니다." do
      assert [] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7], 100, 1)
    end

    test "제공한 start_index가 음수라면 요소의 마지막부터 순서를 새나가 amount만큼 잘라냅니다." do
      assert '\a\b' == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -4, 2)
    end

    test "제공한 start_index가 음수라면 요소의 마지막부터 순서를 새나가 amount만큼 잘라냅니다. amount가 요소의 범위를 넘으면 최대한 잘라냅니다." do
      assert '\a\b\t\n' == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -4, 100)
    end

    test "제공한 start_index가 음수이면서 요소의 범위를 벗어나면 []를 반환합니다." do
      assert [] == MyEnum.slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -100, 3)
    end
  end

  describe "MyEnum.split/2 tests" do
    test "제공한 리스트가 비어있다면 {[], []} 를 반환합니다." do
      assert {[], []} == MyEnum.split([], 10)
    end

    test "count가 양수일때는 left에 남겨질 요소의 개수를 뜻합니다." do
      assert {[1, 2, 3], [4, 5]} == MyEnum.split([1, 2, 3, 4, 5], 3)
    end

    test "count가 양수이면서 요소의 개수 범위보다 크면 모든 요소가 left에 들어갑니다." do
      assert {[1, 2, 3, 4, 5], []} == MyEnum.split([1, 2, 3, 4, 5], 100)
    end

    test "count가 음수일때는 right에 남겨질 요소의 개수를 뜻합니다." do
      assert {[1, 2], [3, 4, 5]} == MyEnum.split([1, 2, 3, 4, 5], -3)
    end

    test "count가 음수이면서 요소의 개수 범위보다 크면 모든 요소가 right에 들어갑니다." do
      assert {[], [1, 2, 3, 4, 5]} == MyEnum.split([1, 2, 3, 4, 5], -1100)
    end
  end

  describe "MyEnum.split_while/2 tests" do
    test "제공한 리스트가 비어있다면 {[], []}를 반환합니다." do
      assert {[], []} == MyEnum.split_while([], fn x -> x end)
    end

    test "함수의 호출 결과로 false가 나올때까지 요소를 left에 넣고 false가 되는 요소를 만나면 그 이후값은 right에 넣습니다." do
      assert {[1, 2], [3, 4]} == MyEnum.split_while([1, 2, 3, 4], fn x -> x < 3 end)
    end

    test "함수의 호출 결과로 false가 나올때까지 요소를 left에 넣고 false가 되는 요소를 만나면 그 이후값은 right에 넣습니다.2" do
      assert {["aa", "bb"], ["ccc", "ddd", "ee"]} ==
               MyEnum.split_while(["aa", "bb", "ccc", "ddd", "ee"], fn x ->
                 String.length(x) == 2
               end)
    end

    test "모든 요소가 함수에 true로 만족하면 left에 요소를 넣습니다." do
      assert {[1, 2, 3, 4, 5, 6, 7], []} ==
               MyEnum.split_while([1, 2, 3, 4, 5, 6, 7], fn _ -> true end)
    end

    test "처음 만난 요소가 false이면 모든 요소를 right에 넣습니다." do
      assert {[], [1, 2, 3, 4, 5, 6, 7]} ==
               MyEnum.split_while([1, 2, 3, 4, 5, 6, 7], fn _ -> false end)
    end
  end

  describe "MyEnum.split_with/2 tests" do
    test "제공한 리스트가 비어있다면 {[], []}를 반환합니다." do
      assert {[], []} == MyEnum.split_with(%{}, fn {_k, v} -> v > 50 end)
    end

    test "함수에 true 한 값은 left false 한 값은 right에 넣어 반환합니다." do
      assert {[4, 2, 0], [5, 3, 1]} ==
               MyEnum.split_with([5, 4, 3, 2, 1, 0], fn x -> rem(x, 2) == 0 end)
    end

    test "함수에 true 한 값은 left false 한 값은 right에 넣어 반환합니다.2" do
      assert {[b: -2, d: -3], [a: 1, c: 1]} ==
               MyEnum.split_with(%{a: 1, b: -2, c: 1, d: -3}, fn {_k, v} -> v < 0 end)
    end

    test "함수에 true 한 값은 left false 한 값은 right에 넣어 반환합니다.3" do
      assert {[], [a: 1, b: -2, c: 1, d: -3]} ==
               MyEnum.split_with(%{a: 1, b: -2, c: 1, d: -3}, fn {_k, v} -> v > 50 end)
    end
  end

  describe "MyEnum.sum/1 tests" do
    test "제공한 리스트가 비어있다면 0을 반환합니다." do
      assert 0 == MyEnum.sum([])
    end

    test "요소를 모두 더 한 값을 반환합니다." do
      assert 21 == MyEnum.sum([1, 2, 3, 4, 5, 6])
    end
  end

  describe "MyEnum.take/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.take([], 100)
    end

    test "제공한 amount가 0이라면 []를 반환합니다." do
      assert [] == MyEnum.take([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 0)
    end

    test "제공한 리스트에서 amount 만큼 요소를 반환합니다." do
      assert [1, 2] == MyEnum.take([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2)
    end

    test "제공한 리스트에서 amount가 요소의 범위 보다 크다면 모든 요소를 반환합니다." do
      assert [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] == MyEnum.take([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 100)
    end

    test "제공한 리스트에서 amount가 음수라면 요소의 끝에서부터 값을 가져옵니다." do
      assert [8, 9, 10] == MyEnum.take([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -3)
    end

    test "제공한 리스트에서 amount가 음수이면서 요소의 범위 보다 크다면 모든 요소를 반환합니다." do
      assert [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] == MyEnum.take([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], -100)
    end
  end

  describe "MyEnum.take_every/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.take_every([], 2)
    end

    test "제공한 nth가 0이라면 []를 반환합니다." do
      assert [] == MyEnum.take_every([1, 2, 3, 4, 5, 6], 0)
    end

    test "제공한 nth가 1이라면 리스트를 다시 되돌려 반환합니다." do
      assert [1, 2, 3, 4, 5] == MyEnum.take_every([1, 2, 3, 4, 5], 1)
    end

    test "요소에서 nth 간격만큼 요소를 가져옵니다." do
      assert [1, 3, 5, 7, 9] == MyEnum.take_every([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2)
    end
  end

  describe "MyEnum.take_while/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.take_while([], fn _ -> true end)
    end

    test "함수를 호출하여 나온값이 false가 될때까지의 요소를 반환합니다." do
      assert [1, 2, 3, 4, 5] ==
               MyEnum.take_while([1, 2, 3, 4, 5, "aa", 6, 7, 8, 9, 10], fn x -> is_number(x) end)
    end

    test "첫 요소가 함수호출에 false값이면 []를 반환합니다." do
      assert [] ==
               MyEnum.take_while([1, 2, 3, 4, 5, "aa", 6, 7, 8, 9, 10], fn x -> is_binary(x) end)
    end
  end

  describe "MyEnum.uniq/1 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.uniq([])
    end

    test "리스트에서 중복된 요소를 제거합니다." do
      assert [1, 2, 3] == MyEnum.uniq([1, 2, 3, 3, 2, 1])
    end

    test "리스트에서 중복된 요소를 제거합니다.2" do
      assert ["a", "b", "d", "e", "c"] == MyEnum.uniq(["a", "b", "d", "a", "e", "c", "c", "e"])
    end

    test "리스트에서 중복된 요소를 제거합니다.3" do
      assert [1, 5, 4, :a, 3, 2, :b, :c] ==
               MyEnum.uniq([1, 5, 4, :a, 3, 1, 2, :b, 2, :c, :a, 1, 2, 3, 4])
    end
  end

  describe "MyEnum.uniq_by/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.uniq_by([], fn x -> x end)
    end

    test "요소의 첫 번째 항목은 유지하며 함수 호출의 결과가 중복되는 요소를 모두 제거하여 반환합니다." do
      assert [1] == MyEnum.uniq_by([1, 2, 3, 4, 5], fn _ -> true end)
    end

    test "요소의 첫 번째 항목은 유지하며 함수 호출의 결과가 중복되는 요소를 모두 제거하여 반환합니다.2" do
      assert [1, 2] == MyEnum.uniq_by([1, 2, 3, 4, 5], fn x -> rem(x, 2) == 0 end)
    end

    test "요소의 첫 번째 항목은 유지하며 함수 호출의 결과가 중복되는 요소를 모두 제거하여 반환합니다.3" do
      assert [{1, :x}, {2, :y}] == MyEnum.uniq_by([{1, :x}, {2, :y}, {1, :z}], fn {x, _} -> x end)
    end

    test "요소의 첫 번째 항목은 유지하며 함수 호출의 결과가 중복되는 요소를 모두 제거하여 반환합니다.4" do
      assert [a: {:tea, 2}, c: {:coffee, 1}] ==
               MyEnum.uniq_by([a: {:tea, 2}, b: {:tea, 2}, c: {:coffee, 1}], fn {_, y} -> y end)
    end
  end

  describe "MyEnum.unzip/1 tests" do
    test "제공한 리스트가 비어있다면 {[], []}를 반환합니다." do
      assert {[], []} == MyEnum.unzip([])
    end

    test "각 요소에서 튜플의 2개의 요소를 추출하여 {[left], [right]}를 반환합니다." do
      assert {[:a, :b, :c], [1, 2, 3]} == MyEnum.unzip([{:a, 1}, {:b, 2}, {:c, 3}])
    end

    test "각 요소에서 튜플의 2개의 요소를 추출하여 {[left], [right]}를 반환합니다.2" do
      assert {[:a, :b, :c, :d], [1, 2, 3, 4]} ==
               MyEnum.unzip([{:a, 1}, {:b, 2}, {:c, 3}, {:d, 4}])
    end

    test "각 요소에서 튜플의 2개의 요소를 추출하여 {[left], [right]}를 반환합니다.3" do
      assert {[:a, :b, 5, :d], [1, 2, :c, 4]} ==
               MyEnum.unzip([{:a, 1}, {:b, 2}, {5, :c}, {:d, 4}])
    end

    test "맵의 각 요소에서 튜플의 2개의 요소를 추출하여 {[left], [right]}를 반환합니다." do
      assert {[:a, :b], [1, 2]} == MyEnum.unzip(%{a: 1, b: 2})
    end
  end

  describe "MyEnum.with_index/2 tests" do
    test "제공한 리스트가 비어있다면 []를 반환합니다." do
      assert [] == MyEnum.with_index([])
    end

    test "각 요소들을 index와 매칭하여 튜플에 래핑된 각 요소를 반환합니다. index가 주어지지 않으면 0입니다." do
      assert [a: 0, b: 1, c: 2] == MyEnum.with_index([:a, :b, :c])
    end

    test "각 요소들을 index와 매칭하여 튜플에 래핑된 각 요소를 반환합니다." do
      assert [a: 3, b: 4, c: 5] == MyEnum.with_index([:a, :b, :c], 3)
    end

    test "각 요소들을 index와 매칭하여 튜플에 래핑된 각 요소를 반환합니다.2" do
      assert [{1, 3}, {2, 4}, {3, 5}] == MyEnum.with_index([1, 2, 3], 3)
    end

    test "fun으로 제공된 함수를 호출하여 나온 요소를 index 와 매칭하여 튜플에 래핑된 각 요소를 반환합니다." do
      assert [{0, :a}, {1, :b}, {2, :c}] ==
               MyEnum.with_index([:a, :b, :c], fn element, index -> {index, element} end)
    end
  end
end
