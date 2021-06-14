# Scripts

Scripts & Resources I have made.

---

### Text Manipulation (vim): 
`:%g!/price/d` - Removes lines that **don't** contain price  

`:%s/foo/bar/g` - Replace all foo with bar

### Adding prefix/suffix (Notepad++): 
```
Find: ^(.*)$
Replace: Prefix $0 Suffix
```

### Updating `~/GitHub`
`for i in */.git; do ( echo $i; cd $i/..; git pull; ); done`

---

## Licensing

The code in this project is licensed under [GNU GPLv3 License](https://choosealicense.com/licenses/gpl-3.0/).
