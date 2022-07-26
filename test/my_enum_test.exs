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
      assert MyEnum.all?([1,2,3], fn x -> x > 0 end)
    end

    test "모든 요소중 하나라도 주어진 함수에 대해서 false라면 false를 반환한다." do
      assert false == MyEnum.all?([1,-1,3], fn x -> x == 0 end)
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
      assert false == MyEnum.any?([1,false,nil], fn x -> x == 0 end)
    end

    test "모든 요소중 하나라도 주어진 함수에 대해서 true라면 true를 반환한다." do
      assert MyEnum.any?([2,4,6], &(rem(&1, 2) == 0))
    end
  end
end
