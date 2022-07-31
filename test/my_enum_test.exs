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
  end

  describe "MyEnum.reverse/2 tests" do
    test "주어진 리스트를 반대로 뒤집고 tail있다면 뒤집은 리스트에 붙여 반환한다." do
      assert [3, 2, 1, 4, 5, 6] == MyEnum.reverse([1, 2, 3], [4, 5, 6])
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
end
