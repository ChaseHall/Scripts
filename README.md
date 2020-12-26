# Scripts

Scripts I use on a daily basis.

---

## Resources for myself

Text Manipulation (vim): 
`:%g!/price/d` - Removes lines that **don't** contain price
`:%s/foo/bar/g` - Replace all foo with bar

Adding prefix/suffix (Notepad++): 
```
Find: ^(.*)$
Replace: Prefix $0 Suffix
```

Pull every subdirectory from git.
```
find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;
```

Clean Docker (Size)
```
docker container prune && docker image prune
```

---

## Licensing

The code in this project is licensed under [GNU GPLv3 License](https://choosealicense.com/licenses/gpl-3.0/).