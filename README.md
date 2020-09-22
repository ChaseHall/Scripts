# Scripts

Scripts I use on a daily basis.
[More scripts that I use for Nebula Host can be found here](https://git.chasehall.net/NebulaHost/Scripts).

---

## Resources for myself

Text Manipulation: 
`:%g!/price/d` - Removes lines that **don't** contain price

Adding prefix/suffix: 
```
Find: ^(.*)$
Replace: Prefix $0 Suffix
```

Pull every subdirectory from git.
`find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;`

---

## Licensing

The code in this project is licensed under [GNU GPLv3 License](https://choosealicense.com/licenses/gpl-3.0/).