defmodule Inmytime.TimebotTest do
  use ExUnit.Case
  alias Inmytime.Timebot

  describe "digest/2" do
    test "parses unix timestamps into UTC and given timezone pairs" do
      result =
        "1526432420"
        |> Timebot.digest("America/Chicago")

      assert result == {:ok, %{datetime: "05/16/2018 @ 1:00am UTC", converted: "05/15/2018 @ 8:00pm CDT"}}
    end
  end

  describe "digest_now/1" do
    test "provides the current UTC and given timezone pair" do
      result = Timebot.digest_now("America/Chicago")

      assert {:ok, %{datetime: _, converted: _}} = result
    end
  end

  describe "format/1" do
    test "returns a datetime in an easy-to-read format" do
      result =
        "1526432420"
        |> Timex.parse!("{s-epoch}")
        |> Timebot.format

      assert result == {:ok, "05/16/2018 @ 1:00am UTC"}
    end
  end

  describe "find_tz/1" do
    test "guesstimates a timezone based on a given ip tuple" do
      result =
        {192, 227, 139, 106}
        |> Timebot.find_tz

      assert result == "America/Chicago"
    end

    test "defaults to Etc/UTC" do
      result =
        {0, 0, 0, 0}
        |> Timebot.find_tz

      assert result == "Etc/UTC"
    end
  end
end
