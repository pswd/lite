<?php echo $header; ?><?php echo $column_left; ?>
<div id="content"><?php echo $content_top; ?>
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <h1><?php echo $heading_title; ?></h1>
  <?php if ($products) { ?>
  <!-- ocshop -->
  <?php if ($product_total>1) { ?>
  <div class="product-filter">
  <div class="display"><?php echo $text_list; ?> <b>/</b> <a onclick="display('grid');"><?php echo $text_grid; ?></a></div>
  <div class="limit">
  <ul>
  <li><?php echo $text_limit; ?></li>
  <?php foreach ($limits as $limites) { ?>
  <li>
  <?php if ($limites['value'] == $limit) { ?>
  <span class="active"><?php echo $limites['text']; ?></a></span>
  <?php } else { ?>
  <a href="<?php echo $limites['href']; ?>"><?php echo $limites['text']; ?></a>
  <?php } ?>
  </li>
  <?php if ($product_total < (int)$limites['value']) break;  ?>
  <?php } ?>
  </ul>
  </div>
  <div class="sort">
  <ul>
  <li>
  <?php echo $text_sort_by; ?>
  </li>
  <li>
  <span   <?php if (($sorts[1]['value'] == $sort . '-' . $order) or ($sorts[2]['value'] == $sort . '-' . $order)) { ?><?php  echo 'class="active"'; ?><?php } ?>><a href="<?php if ($sorts[1]['value'] == $sort . '-' . $order) echo $sorts[2]['href']; else echo $sorts[1]['href']; ?>"><?php echo $text_sort_name; ?></a></span>
  </li>
  <li>
  <span   <?php if (($sorts[3]['value'] == $sort . '-' . $order) or ($sorts[4]['value'] == $sort . '-' . $order)) { ?><?php  echo 'class="active"'; ?><?php } ?>><a href="<?php if ($sorts[3]['value'] == $sort . '-' . $order) echo $sorts[4]['href']; else echo $sorts[3]['href']; ?>"><?php echo $text_sort_price; ?></a></span>
  </li>
  <li>
  <span   <?php if (($sorts[5]['value'] == $sort . '-' . $order) or ($sorts[6]['value'] == $sort . '-' . $order)) { ?><?php  echo 'class="active"'; ?><?php } ?>><a href="<?php if ($sorts[5]['value'] == $sort . '-' . $order) echo $sorts[6]['href']; else echo $sorts[5]['href']; ?>"><?php echo $text_sort_rated; ?></a></span>
  </li>
  <!-- ocshop popularity-->
  <li>
  <span   <?php if (($sorts[7]['value'] == $sort . '-' . $order) or ($sorts[8]['value'] == $sort . '-' . $order)) { ?><?php  echo 'class="active"'; ?><?php } ?>><a href="<?php if ($sorts[7]['value'] == $sort . '-' . $order) echo $sorts[8]['href']; else echo $sorts[7]['href']; ?>"><?php echo $text_sort_viewed; ?></a></span>
  </li>
  <!-- ocshop popularity-->
  </ul>
  </div>
  </div>
  <?php } ?>
  <!-- ocshop -->
  <div class="product-compare"><a href="<?php echo $compare; ?>" id="compare-total"><?php echo $text_compare; ?></a></div>
  <?php echo $column_right; ?>
  <div class="product-list">
    <?php foreach ($products as $product) { ?>
    <div>
      <?php if ($product['thumb']) { ?>
      <div class="image"><a href="<?php echo $product['href']; ?>"><img src="<?php echo $product['thumb']; ?>" title="<?php echo $product['name']; ?>" alt="<?php echo $product['name']; ?>" /></a></div>
      <?php } ?>
      <div class="name"><a href="<?php echo $product['href']; ?>"><?php echo $product['name']; ?></a></div>
      <!-- ocshop description mini -->
      <!-- <div class="description"><?php echo $product['description']; ?></div> -->
	  <div class="description">
		<?php if (!$product['description_mini']) { ?>
		<?php echo $product['description']; ?>
		<?php } else { ?>
		<?php echo $product['description_mini']; ?>
        <?php } ?>
        </div>		
	  <!-- end ocshop description mini -->
      <?php if ($product['price']) { ?>
      <div class="price">
        <?php if (!$product['special']) { ?>
        <?php echo $product['price']; ?>
        <?php } else { ?>
        <span class="price-old"><?php echo $product['price']; ?></span> <span class="price-new"><?php echo $product['special']; ?></span>
        <?php } ?>
        <?php if ($product['tax']) { ?>
        <br />
        <span class="price-tax"><?php echo $text_tax; ?> <?php echo $product['tax']; ?></span>
        <?php } ?>
      </div>
      <?php } ?>
      <?php if ($product['rating']) { ?>
      <div class="rating"><img src="catalog/view/theme/default/image/stars-<?php echo $product['rating']; ?>.png" alt="<?php echo $product['reviews']; ?>" /></div>
      <?php } ?>
      <div class="cart"><input type="button" value="<?php echo $button_cart; ?>" onclick="addToCart('<?php echo $product['product_id']; ?>');" class="button" /></div>
      <div class="wishlist"><a onclick="addToWishList('<?php echo $product['product_id']; ?>');"><?php echo $button_wishlist; ?></a></div>
      <div class="compare"><a onclick="addToCompare('<?php echo $product['product_id']; ?>');"><?php echo $button_compare; ?></a></div>
    </div>
    <?php } ?>
  </div>
  <div class="pagination"><?php echo $pagination; ?></div>
  <?php } else { ?>
  <div class="content"><?php echo $text_empty; ?></div>
  <?php }?>
  <?php echo $content_bottom; ?></div>
<script type="text/javascript"><!--
function display(view) {
	if (view == 'list') {
		$('.product-grid').attr('class', 'product-list');
		
		$('.product-list > div').each(function(index, element) {
			html  = '<div class="right">';
			html += '  <div class="cart">' + $(element).find('.cart').html() + '</div>';
			html += '  <div class="wishlist">' + $(element).find('.wishlist').html() + '</div>';
			html += '  <div class="compare">' + $(element).find('.compare').html() + '</div>';
			html += '</div>';			
			
			html += '<div class="left">';
			
			var image = $(element).find('.image').html();
			
			if (image != null) { 
				html += '<div class="image">' + image + '</div>';
			}
			
			var price = $(element).find('.price').html();
			
			if (price != null) {
				html += '<div class="price">' + price  + '</div>';
			}
					
			html += '  <div class="name">' + $(element).find('.name').html() + '</div>';
			html += '  <div class="description">' + $(element).find('.description').html() + '</div>';
			
			var rating = $(element).find('.rating').html();
			
			if (rating != null) {
				html += '<div class="rating">' + rating + '</div>';
			}
				
			html += '</div>';

						
			$(element).html(html);
		});		
		
		<!-- okshop $('.display').html('<?php echo $text_list; ?> <b>/</b> <a onclick="display(\'grid\');"><?php echo $text_grid; ?></a>'); -->
		$('.display').html('<span class="active"><img src="catalog/view/theme/default/image/list.png" /> <?php echo $text_list; ?></span><a onclick="display(\'grid\');"><img src="catalog/view/theme/default/image/grid_d.png" /> <?php echo $text_grid; ?></a>');
		
		$.cookie('display', 'list'); 
	} else {
		$('.product-list').attr('class', 'product-grid');
		
		$('.product-grid > div').each(function(index, element) {
			html = '';
			
			var image = $(element).find('.image').html();
			
			if (image != null) {
				html += '<div class="image">' + image + '</div>';
			}
			
			html += '<div class="name">' + $(element).find('.name').html() + '</div>';
			html += '<div class="description">' + $(element).find('.description').html() + '</div>';
			
			var price = $(element).find('.price').html();
			
			if (price != null) {
				html += '<div class="price">' + price  + '</div>';
			}
						
			var rating = $(element).find('.rating').html();
			
			if (rating != null) {
				html += '<div class="rating">' + rating + '</div>';
			}
						
			html += '<div class="cart">' + $(element).find('.cart').html() + '</div>';
			html += '<div class="wishlist">' + $(element).find('.wishlist').html() + '</div>';
			html += '<div class="compare">' + $(element).find('.compare').html() + '</div>';
			
			$(element).html(html);
		});	
					
		<!-- $('.display').html('<a onclick="display(\'list\');"><?php echo $text_list; ?></a> <b>/</b> <?php echo $text_grid; ?>'); -->
		$('.display').html('<a onclick="display(\'list\');"><img src="catalog/view/theme/default/image/list_d.png" /> <?php echo $text_list; ?></a><span class="active"><img src="catalog/view/theme/default/image/grid.png" /> <?php echo $text_grid; ?></span>');
		
		$.cookie('display', 'grid');
	}
}

view = $.cookie('display');

if (view) {
	display(view);
} else {
	display('list');
}
//--></script> 
<?php echo $footer; ?>