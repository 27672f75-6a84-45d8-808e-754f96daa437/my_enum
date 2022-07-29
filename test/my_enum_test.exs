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
end
