mkdir -p ckpt/
cd ckpt/

rm -rf cookies.tmp
id="1GHO_PUPwRSYaHLgmWb8wKUD8dvsYw50w"
wget \
    --load-cookies cookies.tmp \
    "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies cookies.tmp --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$id" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$id" \
    -O rc_model.zip \
    && rm -rf cookies.tmp

id="1OH2J6m9j_sUmecbpsW3aYrUDCgxJ-W-P"
wget \
    --load-cookies cookies.tmp \
    "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies cookies.tmp --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$id" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$id" \
    -O qa_model.zip \
    && rm -rf cookies.tmp

unzip rc_model.zip
rm rc_model.zip
unzip qa_model.zip
rm qa_model.zip
