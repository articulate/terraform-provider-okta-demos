# Terraform Provider Okta Demos

The purpose of this repository was to create a curriculum for a conference talk I did. It, serendipitously, is a great way to introduce yourself to using Terraform to build out Okta infrastructure.

## Prerequisites

Follow these steps in order to setup your environment to run this demo.

* [Install Docker](https://docs.docker.com/)
* [Install Docker Compose](https://docs.docker.com/compose/install/)
* [Create an Okta account](https://developer.okta.com/)
* [Create an API token](https://developer.okta.com/docs/guides/create-an-api-token/overview/)
* Clone this repository `git clone git@github.com:articulate/terraform-provider-okta-demos.git`
* Create env file `cp -n .env{.example,}`
* Set environment variables in `.env`

## What is Terraform

[Terraform](https://www.terraform.io/intro/index.html#what-is-terraform-) is a tool for building, changing, and versioning infrastructure safely and efficiently. For those familiar with DevOps tools and terminology, it supports configuration management, configuration orchestration, and provisioning. Configuration management tools allow you to install and manage software on existing systems. Some popular iterations of this type of tooling includes Chef, Puppet, Ansible, and of course Terraform. Configuration orchestration tools allow you to provision the servers themselves. Some well reputed implementations of this type of tooling includes CloudFormation and of course Terraform.

## Why Terraform

* *It supports reusable modules!* With Terraform you can create modules. Modules are essentially an abstracted set of resources that can be referenced multiple times with different inputs. The source can be remote or local. In fact, the top level configuration itself acts as a sort of module. You can provide it variables and run it in multiple contexts. For instance, if you have a stage and production environment, you can reuse the same configuration.

* *It really is code!* It utilizes Hashicorp Configuration Language or HCL syntax. With this comes some great features. It comes with built-in functions, you can even use terraform console command to experiment with them. It supports some advanced expressions including for loops, interpolation, directives, and much more.

* *Version control and validation.* You can store your configuration in version control. This means you can require code review before merging to master, you have a complete history of your infrastructure, you have the power to easily revert changes, and you can validate your infrastructure using static code analysis and/or integration tests.

* *It is safe and predictable!* Terraform provides you the ability to plan before you apply. You can run terraform plan. This pulls down your remote state, refreshes it against your actual downstream resources, compares it to your configuration, and outputs information about how your resources will change.

* *Terraform’s lifecycle is powerful!* A well written provider will refresh your state on every plan. This will detect and output configuration drift. For instance, if a colleague bypasses the Terraform config and manually makes a change in the UI. You will see it and be able to choose to represent it in the config or simply override it. Terraform also provides you with some great commands you can choose to import existing resources, remove resources from state without deleting the actual resource, taint a resource so it is recreated on the next run, and destroy a resource.

* *Use it for everything!* There are community as well as official providers for so many commonly used DevOps services.

## Setting Expectations

Anything exposed by Okta's APIs _can_ be configured with Okta. There are two caveats here, currently there is only a single major contributor. It is often very difficult to keep up with the demand. We will always accept pull requests! [Secondly, there are many operations that are not publicly exposed by Okta](#operations-with-no-api). For these operations we have submitted feature requests and are waiting for their release.

### Operations With No API

* Customization Settings
* User Mappings
* API integrations on preconfigured applications, such as AWS SAML App.
* SAML Roles on AWS SAML App
* Hooking up inline token hooks (they can be created and managed but not flipped on)

## Demos

```sh
docker-compose run terraform init
docker-compose run terraform plan -out=demo.tfplan -var-file=example.tfvars
docker-compose run terraform apply demo.tfplan

// Caution this will destroy your entire env!
docker-compose run terraform destroy -var-file=example.tfvars
```
