# Resistor

**A CLI resistor tool**

I was tired of plugging in resistor codes into various web page forms. I wanted to just type them, and I mainly wanted to re-remember how to build an Elixir [escript](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html), and then use `IO.ANSI` color codes to show the band colors in in the command line.

## Build

This uses Escript. After cloning this repo, use `mix escript.build` to build and then run with `./resistor` like:

```
./resistor black red red gold
```

### Future plans
Eventually, I may need to add a flag to reverse the process. Input a value and return the color codes. But I probably need to clean up after the kids for now.
