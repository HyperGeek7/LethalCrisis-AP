## The Patch File Encryptor

As part of restructuring this project to hopefully get Windows to stop thinking it's a virus, I want to move the decrypt/encrypt process out of the client patcher entirely. And, frankly, this never _needed_ to be on the client side at all. That's just what the code I'd already written did, and I didn't want to reinvent it. So, the obvious alternative: just encrypt the files as part of building the release. At that point, the client just needs to unpack the .p file, extract the lczip file over it, and repack it. Saves us some work on the client side, and removes the encyption code that _might_ have been triggering Windows' heuristics.

This subproject just splits off the encryption code and runs it against a target directory.