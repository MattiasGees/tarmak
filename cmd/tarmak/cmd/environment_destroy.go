package cmd

import (
	"errors"
	"github.com/jetstack/tarmak/pkg/tarmak"
	"github.com/spf13/cobra"
)

// environmentDestroyCmd handles `tarmak environment destroy`
var environmentDestroyCmd = &cobra.Command{
	Use:   "destroy",
	Short: "Destroy a environment",
	PreRunE: func(cmd *cobra.Command, args []string) error {
		store := &globalFlags.Environment.Destroy
		if store.Name == "" {
			return errors.New("you have to give the environment name")
		}
		return nil
	},

	Run: func(cmd *cobra.Command, args []string) {
		t := tarmak.New(globalFlags)
		defer t.Cleanup()

		t.CancellationContext().WaitOrCancel(t.DestroyEnvironment)
	},
}

func init() {
	environmentDestroyFlags(environmentDestroyCmd.PersistentFlags())
	environmentCmd.AddCommand(environmentDestroyCmd)
}
