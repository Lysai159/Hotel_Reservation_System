package uef.edu.vn.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Cart implements Serializable {

    private final List<CartItem> items = new ArrayList<>();

    public List<CartItem> getItems() {
        return items;
    }

    public int getItemCount() {
        return items.size();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public BigDecimal getGrandTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            if (item.getTotalAmount() != null) {
                total = total.add(item.getTotalAmount());
            }
        }
        return total;
    }

    public void addItem(CartItem item) {
        items.add(item);
    }

    public void removeItem(String itemId) {
        Iterator<CartItem> iterator = items.iterator();
        while (iterator.hasNext()) {
            if (iterator.next().getItemId().equals(itemId)) {
                iterator.remove();
                return;
            }
        }
    }

    public void clear() {
        items.clear();
    }
}
