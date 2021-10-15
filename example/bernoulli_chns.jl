######### StanSample Bernoulli example  ###########

using StanSample

ProjDir = @__DIR__

bernoulli_model = "
data {
  int<lower=1> N;
  int<lower=0,upper=1> y[N];
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(1,1);
  y ~ bernoulli(theta);
}
";

data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

# Keep tmpdir across multiple runs to prevent re-compilation
tmpdir = joinpath(@__DIR__, "tmp")
tmpdir = mktempdir()

sm = SampleModel("bernoulli", bernoulli_model;
  method = StanSample.Sample(
    save_warmup=false,                           # Default
    thin=1,
    adapt = StanSample.Adapt(delta = 0.85)),
  tmpdir = tmpdir,
);

rc = stan_sample(sm; data, n_chains=2, seed=12);

if success(rc)
  chns = read_samples(sm)
  display(chns)
end