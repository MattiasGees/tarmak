// Copyright Jetstack Ltd. See LICENSE for details.
package cmd

import (
	flag "github.com/spf13/pflag"
	"github.com/spf13/cobra"
)

var environmentCmd = &cobra.Command{
	Use:     "environments",
	Short:   "Operations on environments",
	Aliases: []string{"environment"},
}

func environmentDestroyFlags(fs *flag.FlagSet) {
	store := &globalFlags.Environment.Destroy

	fs.BoolVarP(
		&store.Force,
		"force",
		"f",
		false,
		"destroy a complete environment",
	)

	fs.StringVarP(
		&store.Name,
		"name",
		"n",
		"",
		"name of the environment to destroy",
	)
}

func init() {
	RootCmd.AddCommand(environmentCmd)
}
