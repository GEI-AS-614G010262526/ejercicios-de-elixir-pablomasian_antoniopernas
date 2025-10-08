defmodule EratostenesTest do
  use ExUnit.Case

  describe "primos/1 - versión concurrente" do
    test "devuelve lista vacía para números menores que 2" do
      assert Eratostenes.primos(1) == []
      assert Eratostenes.primos(0) == []
      assert Eratostenes.primos(-5) == []
    end

    test "devuelve [2] para n = 2" do
      assert Eratostenes.primos(2) == [2]
    end

    test "encuentra primos hasta 10" do
      resultado = Eratostenes.primos(10)
      expected = [2, 3, 5, 7]
      assert resultado == expected
    end

    test "encuentra primos hasta 20" do
      resultado = Eratostenes.primos(20)
      expected = [2, 3, 5, 7, 11, 13, 17, 19]
      assert resultado == expected
    end

    test "encuentra primos hasta 30" do
      resultado = Eratostenes.primos(30)
      expected = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
      assert resultado == expected
    end

    test "prueba con número primo como límite" do
      resultado = Eratostenes.primos(13)
      expected = [2, 3, 5, 7, 11, 13]
      assert resultado == expected
    end

    test "prueba con número compuesto como límite" do
      resultado = Eratostenes.primos(15)
      expected = [2, 3, 5, 7, 11, 13]
      assert resultado == expected
    end

    test "prueba concurrencia con números más grandes" do
      resultado = Eratostenes.primos(50)
      expected = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
      assert resultado == expected
    end
  end
end