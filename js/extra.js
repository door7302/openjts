document.addEventListener("DOMContentLoaded", function() {
    const lightboxLinks = [];

    document.querySelectorAll('.md-typeset img').forEach(img => {
        // Skip if already inside a link
        if (img.parentNode.tagName.toLowerCase() === 'a') return;

        // Wrap image in <a> for lightbox
        const link = document.createElement('a');
        link.href = img.src;
        link.classList.add('glightbox');
        img.parentNode.insertBefore(link, img);
        link.appendChild(img);

        // Add zoom icon on hover
        link.style.position = 'relative';
        link.style.display = 'inline-block';
    });

    // Initialize GLightbox
    GLightbox({ selector: '.glightbox' });
});