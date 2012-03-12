function latent_samples = ...
      sample_latent_posterior(data, responses, test, inference_method, ...
                              mean_function, covariance_function, ...
                              likelihood, hypersamples, num_samples, jitter)

  if (nargin < 11)
    jitter = 1e-6;
  end

  [latent_means, latent_covariances, hypersample_weights] = ...
      estimate_latent_posterior(data, responses, test, inference_method, ...
                                mean_function, covariance_function, ...
                                likelihood, hypersamples, true);

  [num_components, dimension] = size(latent_means);

  components = randsample(num_components, num_samples, true, hypersample_weights);
  latent_samples = zeros(num_samples, dimension);

  for i = 1:num_components
    latent_samples(components == i, :) = ...
        randnorm(nnz(components == i), latent_means(i, :)', ...
                 [], squeeze(latent_covariances(i, :, :)) + jitter * eye(dimension))';
  end

end