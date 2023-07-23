# Config Tests

To ensure we don't break existing configs, we validate the output against known values. To add a new one you can explore the result of the test configs with:
```
cue export ./tests -e 'test."empty sampler".out.k8s' --out cue
``` 