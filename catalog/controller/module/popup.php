<?php 
class ControllerModulePopup extends Controller {
	public function index() {			$this->document->addScript('catalog/view/javascript/popup.js');		if (file_exists('catalog/view/theme/' . $this->config->get('config_template') . '/stylesheet/popup.css')) {			$this->document->addStyle('catalog/view/theme/' . $this->config->get('config_template') . '/stylesheet/popup.css');		} else {			$this->document->addStyle('catalog/view/theme/default/stylesheet/popup.css');		}			}
	
	public function minicart() {
	
				
		$this->language->load('module/popup');
		
      	if (isset($this->request->get['remove'])) {
          	$this->cart->remove($this->request->get['remove']);
			
			unset($this->session->data['vouchers'][$this->request->get['remove']]);
      	}	
			
		// Totals
		$this->load->model('setting/extension');
		
		$total_data = array();					
		$total = 0;
		$taxes = $this->cart->getTaxes();
		
		$sort_order = array(); 
		
		$results = $this->model_setting_extension->getExtensions('total');
		
		foreach ($results as $key => $value) {
			$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
		}
		
		array_multisort($sort_order, SORT_ASC, $results);
		
		foreach ($results as $result) {
			if ($this->config->get($result['code'] . '_status')) {
				$this->load->model('total/' . $result['code']);
	
				$this->{'model_total_' . $result['code']}->getTotal($total_data, $total, $taxes);
			}
			
			$sort_order = array(); 
		  
			foreach ($total_data as $key => $value) {
				$sort_order[$key] = $value['sort_order'];
			}

			array_multisort($sort_order, SORT_ASC, $total_data);			
		}		
		
		$this->data['totals'] = $total_data;
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		
		$this->data['text_items'] = sprintf($this->language->get('text_items'), $this->cart->countProducts() + (isset($this->session->data['vouchers']) ? count($this->session->data['vouchers']) : 0), $this->currency->format($total));
		$this->data['text_empty'] = $this->language->get('text_empty');
		$this->data['text_cart'] = $this->language->get('text_cart');
		$this->data['text_skip'] = $this->language->get('text_skip');
		$this->data['text_wishlist'] = $this->language->get('text_wishlist');
		$this->data['text_checkout'] = $this->language->get('text_checkout');
		
		$this->data['button_remove'] = $this->language->get('button_remove');
		
		$this->load->model('tool/image');
		
		$this->data['products'] = array();
			
		foreach ($this->cart->getProducts() as $product) {
			if ($product['image']) {
				$image = $this->model_tool_image->resize($product['image'], $this->config->get('config_image_cart_width'), $this->config->get('config_image_cart_height'));
			} else {
				$image = '';
			}
							
			$option_data = array();
			
			foreach ($product['option'] as $option) {
				if ($option['type'] != 'file') {
					$value = $option['option_value'];	
				} else {
					$filename = $this->encryption->decrypt($option['option_value']);
					
					$value = utf8_substr($filename, 0, utf8_strrpos($filename, '.'));
				}				
				
				$option_data[] = array(								   
					'name'  => $option['name'],
					'value' => (utf8_strlen($value) > 20 ? utf8_substr($value, 0, 20) . '..' : $value),
					'type'  => $option['type']
				);
			}
			
			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$price = false;
			}

			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$total = $this->currency->format($this->tax->calculate($product['total'], $product['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$total = false;
			}
													
			$this->data['products'][] = array(
				'key'      => $product['key'],
				'thumb'    => $image,
				'name'     => $product['name'],
				'model'    => $product['model'], 
				'option'   => $option_data,
				'quantity' => $product['quantity'],
				'price'    => $price,	
				'total'    => $total,	
				'href'     => $this->url->link('product/product', 'product_id=' . $product['product_id'])		
			);
		}
		
		// Gift Voucher
		$this->data['vouchers'] = array();
		
		if (!empty($this->session->data['vouchers'])) {
			foreach ($this->session->data['vouchers'] as $key => $voucher) {
				$this->data['vouchers'][] = array(
					'key'         => $key,
					'description' => $voucher['description'],
					'amount'      => $this->currency->format($voucher['amount'])
				);
			}
		}
		
		
		$this->data['popup_status'] = 'cart';

		
		$this->data['cart'] = $this->url->link('checkout/checkout');
						
		$this->data['checkout'] = $this->url->link('checkout/checkout', '', 'SSL');
	
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/popup.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/popup.tpl';
		} else {
			$this->template = 'default/template/module/cart.tpl';
		}
				
		$this->response->setOutput($this->render());		
	}
	
	
	
	public function wishlist() {
	
		$this->language->load('module/popup');
		
		$this->data['text_skip'] = $this->language->get('text_skip');
		
		$this->data['text_wishlist'] = $this->language->get('text_wishlist');
		
		$this->data['text_wishlist'] = $this->language->get('text_wishlist');
		
		$this->data['url_wishlist'] = $this->url->link('account/wishlist')	;
		
		$this->data['popup_status'] = 'wish';
	
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/popup.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/popup.tpl';
		} else {
			$this->template = 'default/template/module/cart.tpl';
		}
				
		$this->response->setOutput($this->render());
		
			
	}
	
	public function compare() {
	
		$this->language->load('module/popup');
		
		$this->data['text_skip'] = $this->language->get('text_skip');
		
		$this->data['text_wishlist'] = $this->language->get('text_compare');
		
		$this->data['text_wishlist'] = $this->language->get('text_compare');
		
		$this->data['url_compare'] = $this->url->link('product/compare')	;
		
		$this->data['popup_status'] = 'compare';
	
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/popup.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/popup.tpl';
		} else {
			$this->template = 'default/template/module/cart.tpl';
		}
				
		$this->response->setOutput($this->render());
		
			
	}
	
	
}
?>