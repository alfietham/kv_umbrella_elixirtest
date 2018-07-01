defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  setup context do
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "run create command", %{registry: registry} do
    assert KVServer.Command.run({:create, "testbucket"}, registry) == {:ok, "OK\r\n"}

    assert {:ok, _} = KV.Registry.lookup(registry, "testbucket")
  end

  test "run create, put and get commands", %{registry: registry} do
    assert KVServer.Command.run({:create, "testbucket"}, registry) == {:ok, "OK\r\n"}

    assert {:ok, _} = KV.Registry.lookup(registry, "testbucket")

    item = "milk"
    value = 3

    assert KVServer.Command.run({:put, "testbucket", item, value}, registry) == {:ok, "OK\r\n"}

    assert KVServer.Command.run({:get, "testbucket", item}, registry) ==
             {:ok, "#{value}\r\nOK\r\n"}
  end
end
