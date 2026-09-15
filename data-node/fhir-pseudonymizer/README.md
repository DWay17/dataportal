# Additional information for the fhir-pseudonymizer

https://github.com/miracum/fhir-pseudonymizer 


This example uses the vfps as pseudonymization service, make sure to change it to your local pseudonymization service of choice.

It is important that the pseudonyms are kept save and persisted over a long period of time so that project based re-identification can be guranteed should the need arise.

## DIMP configuration - fall-back and per project configuration

The DIMP configuration is not mounted here per project. aether sends each DUP project's DIMP YAML to the fhir-pseudonymizer with every `$de-identify` request, so the rules that are applied come from the project's aether pipeline configuration (`services.dimp.anonymization_config`).

The [redact-all.yaml](./redact-all.yaml) mounted by this compose file is only the fall-back for requests that arrive without such a configuration - it redacts everything, so a missing or forgotten project configuration cannot produce un-DIMPed data. Keep it as it is.

The DIMP DUP base example has moved to [../aether/dimp_dup_base.yaml](../aether/dimp_dup_base.yaml), next to the aether pipeline configuration, and has to be adjusted on a per project basis.

For each project unless otherwise specified the following need to be adjusted:

1. `parameters.cryptoHashKey` needs to be filled with a crypohashkey for the project. You can use the following command for this `openssl rand -hex 32`
2. The `project-prefix-here` part in the `dimp_dup_base.yaml` should be replaced with your project prefix.

Additionally projects can differ in other DIMP aspects, which will be provided as part of each projects DIMP specification - e.g. birtdate aggregated to year instead of year-month.

See the [DIMP documentation](../../docs/data-node/DIMP.md) for the full per project setup.


## Using the vfps

If a site is using the vfps of this example, the fhir-pseudonymizer needs the pseudonym domains used in the project's DIMP YAML (e.g. [../aether/dimp_dup_base.yaml](../aether/dimp_dup_base.yaml)) to exist in the vfps.

The base YAML re-pseudonymizes four identifier types, so it needs four namespaces. With `project-prefix-here` replaced by your project prefix, these are:

- `<project-prefix>-my-dic-encounter-vn-namespace`
- `<project-prefix>-my-dic-patient-mr-namespace`
- `<project-prefix>-my-dic-patient-pseuded-namespace`
- `<project-prefix>-my-dic-patient-anonyed-namespace`

If a namespace is missing the `fhir-pseudonymizer` fails and breaks the pipeline, so create them before the first DIMP run.

To create one in the vfps:

```
curl --request POST \
  --url http://localhost:8089/v1/namespaces \
  --header 'content-type: application/json' \
  --data '{
  "name": "<project-prefix>-my-dic-patient-mr-namespace",
  "pseudonymGenerationMethod": "PSEUDONYM_GENERATION_METHOD_UNSPECIFIED",
  "pseudonymLength": 32,
  "pseudonymPrefix": "string",
  "pseudonymSuffix": "string",
  "description": "string"
}'
```

[example-project-create-namespaces-vfps.sh](../example-dup-project/example-project-create-namespaces-vfps.sh) creates all four for the example project and is the easiest thing to copy and adapt.