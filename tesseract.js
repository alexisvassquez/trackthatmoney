<script src="https://cdn.jsdelivr.net/npm/tesseract.js@2"></script>
<script>
function recognizeText(input) {
    const file = input.files[0];
    if (file)
        Tesseract.recognize(
            file,
            'eng',
            {
                logger: m => console.log(m)
            }
        ).then(({ data: { text } }) => {
        console.log(text);
        document.getElementById('ocr_text').innerText = text;
        })
        .catch(err => {
        console.error(err);
        });
    }
</script>