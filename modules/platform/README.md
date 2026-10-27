# PLATFORM IMAGE

Not used by default in the provisioner, this allows use of standard AMIs 
defined here, without having to know the AMI ids.
If you know your AMI ID, then this is not needed.

## Pinning an AMI

By default the module resolves the newest image matching the platform, so a
re-apply after a new image release changes the AMI id and rolls the consuming
ASGs. Set `ami` to an image id to skip the lookup entirely and keep the rest
of the platform data (connection details, user_data) intact; upgrades then
happen only when that value is changed.
