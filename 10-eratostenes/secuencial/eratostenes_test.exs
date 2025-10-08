defmodule EratostenesTest do
  use ExUnit.Case

  describe "primos/1" do
    test "devuelve lista vacía para números menores que 2" do
      assert Eratostenes.primos(1) == []
      assert Eratostenes.primos(0) == []
      assert Eratostenes.primos(-5) == []
    end

    test "devuelve [2] para n = 2" do
      assert Eratostenes.primos(2) == [2]
    end

    test "encuentra primos hasta 10" do
      assert Eratostenes.primos(10) == [2, 3, 5, 7]
    end

    test "encuentra primos hasta 20" do
      assert Eratostenes.primos(20) == [2, 3, 5, 7, 11, 13, 17, 19]
    end

    test "encuentra primos hasta 30" do
      expected = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
      assert Eratostenes.primos(30) == expected
    end

    test "prueba con número primo como límite" do
      assert Eratostenes.primos(13) == [2, 3, 5, 7, 11, 13]
    end

    test "prueba con número compuesto como límite" do
      assert Eratostenes.primos(15) == [2, 3, 5, 7, 11, 13]
    end
  end
end