+++
author = "skyler"
title = "PDF2SVG the right way"
draft = true
date = "2016-12-05T08:05:03-07:00"
+++

## The Issue with PDF's:
There are a lot of reasons you might be looking to convert PDF files to SVG. At canopy, we needed to be able to convert high resolution PDF's into a format which we could display as previews inside our document management services. These documents might come from any source, so the need to replicate them 1:1 is critical. There is already a variety of solutions out there, but none of which encapsulated solutions to all of the problems we had with them.

PDS's are complex documents with Fonts, Vector Graphics, and Raster Graphics.

### Fonts:
PDF's may have fonts embedded inside of them. This can cause an issue with rendering. If the fonts does not exist in the users system, then the SVG is not going to be reproduced in the same way that the PDF was. Our SVG's need to reference the font in the users system. That way if the user has the font, then the SVG will render properly, otherwise we use next best guess.

In the future we might take the fonts from the PDF and embed them right into the SVG themselves, but until that requirement comes, we are happy with the fonts the way they are.

### Vector Graphics:
This was our primary reason for using SVG for our preview files. SVG maintains vector data, keeping the files a fraction of the size of their rasterized counterparts. Not to mention the infinite level of quality we get to maintain with them.

### Raster Graphics:
About the only setback to SVG's is embedded raster images because we do not apply any additional compression to them, however, in the future, if it becomes a problem we probably can compress during the conversion process.

## Extracting Fonts
In our testing, we were able to find a way to extract fonts from PDF's in order to later use them for re-embedding into the SVG's. Here is an example of what you might use to extract fonts from a PDF.

```python
from pdfrw import PdfReader
from pprint import pprint
x = PdfReader(path_to_file)
import zlib
import os

def flate_decode(obj):
    stream = obj.stream.encode('Latin-1')
    decompressobj = zlib.decompressobj
    dco = decompressobj()
    return dco.decompress(stream)

filters = {
    '/FlateDecode': flate_decode
}

def save_font(filter, font, name):
    if not os.path.exists(path + name):
        with open(path + name, "wb") as text_file:
            pprint('savind: '+name, indent=2)
            text_file.write(filters[filter](font))

for page in x.pages:
    if page.Resources.Font is not None:
        for resource, value in page.Resources.Font.items():
            d = value.FontDescriptor
            if d is not None and d.FontFile is not None:
                save_font(d.FontFile.Filter, d.FontFile, d.FontName)
            if d is not None and d.FontFile2 is not None:
                save_font(d.FontFile2.Filter, d.FontFile2, d.FontName + '.ttf')
            if d is not None and d.FontFile3 is not None:
                if d.FontFile3.Subtype == '/Type1C':
                    print('TODO: Handle Type1C: '+d.FontName)
                if d.FontFile3.Subtype == '/CIDFontType0C':
                    print('TODO: Handle CIDFontType0C')
                if d.FontFile3.Subtype == '/OpenType':
                    save_font(d.FontFile2.Filter, d.FontFile2, d.FontName + '.otf')

```

## Binaries
Someday I would really like to write my own PDF parser SVG creator, if ever I am feeling up to the task. For now I have tried a variety of them and they all have their issues.

The main converter that everyone seems to use is [PDF2SVG](http://www.cityinthesky.co.uk/opensource/pdf2svg/). It's really simple under the hood. It uses [poppler](https://poppler.freedesktop.org/) and [cairo](https://www.cairographics.org/). One is used for parsing the PDF and the other for creating SVGs. The problem with this one comes when we attempt to convert complex PDFs. If you don't care about 1:1 replication, this is a fine option.

There are also a variety of proprietary options but none of them were ideal for our needs. Also a lot of paid services were using poppler/cairo or just PDF2SVG anyways, and got the same kind of results we were getting. We wanted better.

## Inkscape
In the end we found Inkscape to be the best solution. In fact this was the first converter we found, but we were unhappy with the fact that (as of the time of writing this) you can only convert one page of a PDF at a time. Just the first page. Not helpful. But we were able so use [pdfrw](https://github.com/pmaupin/pdfrw) to iterate over all the pages, outputting one page at a time to PDF and then converting that PDF to SVG with an Inkscape running as a subprocess. This actually seems to be about as fast as PDF2SVG, and the results are FANTASTIC. So long as the font exists on the system the PDF was originated from, the SVG was indistinguishable.

```py
for i, p in enumerate(doc.pages):
  PdfWriter().addpage(p).write(pdf_path)
  command = ['inkscape', '--without-gui', '--file=%s' % pdf_path,
            '--export-plain-svg=%s' % svg_path]
  create = asyncio.create_subprocess_exec(*command)
  proc = await create
  await proc.wait()
```
