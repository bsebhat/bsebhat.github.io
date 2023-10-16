---
title: "Trying Screenshot Pasting"
date: 2023-10-16T00:22:10-07:00
---

I'm trying some Visual Studio extensions for pasting screenshots from my clipboard. Here's a picture of Magneto I copied from the internet: ![magneto](../magneto.png)

I'm using the [Markdown Paste extension](https://marketplace.visualstudio.com/items?itemName=telesoho.vscode-markdown-paste-image#:~:text=Smartly%20paste%20in%20Markdown%20by,insert%20link%20code%20to%20Markdown.) in Visual Studio. I had to install the `xclip` package.

I like that It works smoothly. Like, I do Ctrl+Alt+v, and a dialog pops up where I can name the copied picture, and it puts the file in the current directory, with the markdown code.

One problem. For some reason, when I'm using images in markdown in this hugo blog, and they're in the same directory, I have to add a `../` before the image name. Like it's in a higher directory.

I think it's because hugo is doing page bundling for this blog post. So the path for this markdown file is `blog/2023/10/16/trying-screenshot-pasting.md`, and the blog url is `blog/2023/10/16/trying-screenshot-pasting/`, so I add the `../` to the image path so that it references the `blog/2023/10/16` directory and not the `blog/2023/10/16/trying-screenshot-pasting/`.

That's why it's `../magneto.png` and not just `magneto.png`. I think. I don't know if I should spend too much time on this. The extension makes pasting screenshots easier. It's just annoying to have to keep prepending that `../` to the image path reference in the markdown.

Anyway, here's a picture of Manifold looking cool in his S.W.O.R.D. fit: ![manifold](../manifold.png)