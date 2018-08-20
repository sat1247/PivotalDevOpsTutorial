# PivotalDevOpsTutorial

This repo contains a series of pipelines and a sample app used to show how to implement an Unbreakable DevOps Pipeline utilizing Concourse, Dynatrace, and Pivotal Cloud Foundry.

The goal this tutorial is the creation of a full end-to-end Concourse pipeline, fully monitored with Dynatrace. The end-state pipeline includes automated pushing of deployment metadata to Dynatrace (shifting right), automated approval and rejection of builds coming out of staging against Dynatrace data (shift left), and using blue/green deployment techniques coupled with Dynatrace data to approve promotion of builds in production as well. 

This pipeline assumes that the CloudFoundry implementation is already monitored with the [Dynatrace BOSH add-on for PCF](https://network.pivotal.io/products/dynatrace-fullstack-addon) or the BOSH add-on via [github](https://github.com/Dynatrace/bosh-oneagent-release) for open-source CloudFoundry.

Apologies if documentation is sparse here, this is a living document and will be RAPIDLY improved in the coming weeks! ;)

## Pre-Requisites

1. CloudFoundry environment monitored by Dynatrace
2. github account to clone this repo
3. concourse installation [find more here](https://concourse-ci.org/setup-and-operations.html)
4. fly cli loaded, see step 3

### Our First Pipeline
This first pipeline represents our starting point. This pipeline pushes an application to stage and then conducts some load against it. A manual step is necessary to use concourse to promote the build to production where a blue/green deployment will automatically take place. 
``` cd PivotalDevOpsTutorial
fly -t <concourse-instance-name> set-pipeline -c ci/01-pipeline.yml -p PivotalDevOpsTutorial -l ci/credentials.yml
 ```
### Our Second Pipeline
This second pipeline adds the [Dynatrace concourse resource](https://github.com/akirasoft/dynatrace-resource), allowing us to "shift-right" the deployment information to Dynatrace.
``` cd PivotalDevOpsTutorial
fly -t <concourse-instance-name> set-pipeline -c ci/02-pipeline.yml -p PivotalDevOpsTutorial -l ci/credentials.yml
 ```
### Our Third Pipeline
Our third pipeline adds the ability to fetch performance data from Dynatrace after a release, and push it up to a Dynatrace custom-device for storage and charting. This performance data is also validated both before attempting the production deployment as well as before promoting the new production deployment to the main route. The definition of the metrics being retrieved, the comparisons being made, validation criteria are all governmend by the monspec file, a small json document describing some of our Non-Functional-Requirements that govern our release. A sample monspec file is provided in this repo to go along with the workshop. Additionally, we utilize a Concourse job to prepare the Dynatrace custom device to recieve the metrics we've defined in our monspec. The custom device is also populated with information about our pipeline as well. This is once again stored in a small json document with a sample provided in this repo. 

``` cd PivotalDevOpsTutorial
fly -t <concourse-instance-name> set-pipeline -c ci/03-pipeline.yml -p PivotalDevOpsTutorial -l ci/credentials.yml
 ```
The init-dynatrace task is a one-time job necessary to initialize the Dynatrace custom device that will be receiving our pipeline's monspec data.

### Our Fourth Pipeline
The fourth pipeline adds the [Dynatrace UFO resource](https://github.com/akirasoft/dynatrace-ufo-resource) which allows easy implementation of the Dynatrace UFO information radiator within the pipeline allowing easy visualization of pipeline status. 

``` cd PivotalDevOpsTutorial
fly -t <concourse-instance-name> set-pipeline -c ci/04-pipeline.yml -p PivotalDevOpsTutorial -l ci/credentials.yml
 ```


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Andi Grabner's AWS DevOps Tutorial: [AWSDevOpsTutorial](https://github.com/Dynatrace/AWSDevOpsTutorial)
Pivotal's Concourse Pipeline Samples, specifically the [blue-green-app-deployment](https://github.com/pivotalservices/concourse-pipeline-samples/tree/master/pipelines/appdev/blue-green-app-deployment)