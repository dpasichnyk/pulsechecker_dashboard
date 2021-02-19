document.addEventListener('DOMContentLoaded', () => {
    (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
        const notification = $delete.parentNode;

        // add addEventListener for close btn
        $delete.addEventListener('click', () => {
            notification.parentNode.removeChild(notification);
        });
        // hide notification after 3 seconds
        setTimeout(() => {
            notification.classList.add('hide');
            notification.parentNode.removeChild(notification);
        }, 3000);
    });
})
