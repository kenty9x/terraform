package main
import (
        "github.com/hashicorp/terraform-plugin-sdk/helper/schema"
)
func Provider() *schema.Provider {
        return &schema.Provider{
                ResourcesMap: map[string]*schema.Resource{},
        }
}

// The helper/schema library is part of Terraform Core. It abstracts many of the complexities and ensures consistency between providers. The example above defines an empty provider (there are no resources).

// The *schema.Provider type describes the provider's properties including:

// the configuration keys it accepts

// the resources it supports

// any callbacks to configure