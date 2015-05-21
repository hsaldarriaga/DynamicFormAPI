# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready( () ->
	if $('#fields')?
		init()
		set_events()
		window.field_count = 0
		window.field_element = new Array()
	)
init = () ->
	###
	content_text = $('#step_content').val()
	if !content_text.length is 0
		content_json = $.parseJSON(content_text)
		content_json.Fields.each((index, value) ->
			p_elem = $('<p></p>')
			p_elem_content = new Object()
			p_elem_content.id = value.id
			p_elem_content.caption = value.caption
			p_elem_content.field_type = value.field_type
			if !(value.field_type is "2" or value.field_type is "3")
				possible_values_p_elem = new Object()
				value.possible_values.each((index, value) ->
					possible_values_p_elem.push(value)
					)
				p_elem_content.possible_values = possible_values_p_elem
			window.field_count = value.id + 1
		)
		p_elem.val(JSON.stringify(p_elem_content))
		if !(p_elem_content.field_type is "3")
			window.field_element.push(p_elem_content)
		$('#fields').append(p_elem)
		update_select()
		change_selection_decision()
	###
set_events = () ->
	$('#add_field').click(add_field)
	$('#field_type').on('change', change_selection)
	$('#decision_field_select').on('change', change_selection_decision)
	$('#add_decision').click(add_decision)
	$('#decision_button_container').hide()
	$('#add_branch').click(add_branch)
	$('#add_possibility').click(add_possibility)
add_field = ()->
	p_elem = $('<p></p>')
	p_elem_content = new Object()
	p_elem_content.id = window.field_count
	p_elem_content.caption = $('#caption').val()
	p_elem_content.field_type = $('#field_type').val()
	if !(p_elem_content.field_type is "2" or p_elem_content.field_type is "3")
		possible_values_p_elem = new Array()
		$('#possibilities_container').children().each ((index,value) ->
			possible_values_p_elem.push($(this).text())
			)
		p_elem_content.possible_values = possible_values_p_elem
	p_elem.text(JSON.stringify(p_elem_content))
	$('#fields').append(p_elem)
	if !(p_elem_content.field_type is "3")
		window.field_element.push(p_elem_content)
	window.field_count = window.field_count + 1
	update_select()
	$('#decisions').empty()
	change_selection_decision()
add_possibility = () ->
	container = $('#possibilities_container')
	possibility = $('<li class="vertical-a"></li>')
	possibility.text($('#add_text_possibility').val())
	container.append(possibility)
change_selection = () ->
	cont = $('#possibilities_container')
	cont.empty()
	switch (parseInt($('#field_type').val())) 
		when 0
			$('#custom_possibilities').show()
			$('#possibilities').show()
		when 1
			$('#custom_possibilities').hide()
			cont.append($('<li class="vertical-a">True</li>'))
			cont.append($('<li class="vertical-a">False</li>'))
			$('#possibilities').show()
		when 2
			$('#possibilities').hide()
			$('#custom_possibilities').hide()
		when 3
			$('#possibilities').hide()
			$('#custom_possibilities').hide()
update_select = () ->
	window.field_element_choosen = window.field_element
	$('#branches').empty()
	select_d = $('#decision_field_select')
	select_d.empty()
	$.each(window.field_element_choosen, (index, value) ->
		val_add_string = '<option value="'
		val_add_string = val_add_string + value.id
		val_add_string = val_add_string +  '">'
		val_add_string = val_add_string + value.id
		val_add_string = val_add_string + '</option>'
		val_add = $(val_add_string)
		select_d.append(val_add)
		)
	$('#decision_button_container').hide()
	$('#add_branch').show()
change_selection_decision = () ->
	sel_value = parseInt($('#decision_field_select').val())
	field_obj = null
	$.each(window.field_element_choosen, (index,value) ->
		if value.id == sel_value
			field_obj = value
			window.actual_field_index = index
			return false
		)
	if !(field_obj == null)
		cond_select = $('#select_condition_decision')
		switch(parseInt(field_obj.field_type))
			when 0
				$('#li_condition').hide()
				$('#li_value').hide()
				$('#li_equal_to').show()
				cond_select.empty()
				$.each(field_obj.possible_values, (index,value) ->
					val_string = '<option value="'
					val_string = val_string + value
					val_string = val_string + '">'
					val_string = val_string + value
					val_string = val_string + "</option>"
					cond_select.append($(val_string))
					)
			when 1
				$('#li_condition').hide()
				$('#li_value').hide()
				$('#li_equal_to').show()
				cond_select.empty()
				cond_select.append($('<option value="True">True</option>'))
				cond_select.append($('<option value="False">False</option>'))
			when 2
				$('#li_condition').show()
				$('#li_value').show()
				$('#li_equal_to').hide()
		window.actual_field = field_obj
add_branch = () ->
	cond_select = $('#select_condition_decision')
	remove_child = $("#decision_field_select option[value=\"" + window.actual_field_index + "\"]")
	remove_child.remove()
	branch = new Object()
	branch_container = $('#branches')
	switch (parseInt(window.actual_field.field_type))
		when 0
			branch.field_id = window.actual_field.id
			branch.comparison_type = '='
			branch.value = $('#select_condition_decision').val()
			branch_container.append($("<p>" + JSON.stringify(branch) + "</p>"))
		when 1
			branch.field_id = window.actual_field.id
			branch.comparison_type = '='
			branch.value = $('#select_condition_decision').val()
			branch_container.append($("<p>" + JSON.stringify(branch) + "</p>"))
		when 2
			branch.field_id = window.actual_field.id
			branch.comparison_type = $('#number_condition_decision').val()
			branch.value = $('#number_value').val()
			branch_container.append($("<p>" + JSON.stringify(branch) + "</p>"))
	if ($('#decision_field_select').has('option').length == 0)
		$('#decision_button_container').show()
		$('#add_branch').hide()
	change_selection_decision()
add_decision = () ->
	branches_html = $('#branches')
	decision = new Object()
	branches = new Array()
	branches_html.children().each( (index, value) ->
			branches.push(JSON.parse($(this).text()))
		)
	decision.branch = branches
	decision.go_to_step = $('#go_to_step').val() 
	branches_html.empty()
	p_p = $('<p></p>')
	content_text = JSON.stringify(decision)
	p_p.text(content_text)
	$('#decisions').append(p_p)
	$('#decision_button_container').hide()
	$('#add_branch').show()
	update_select()
	add_to_content()
add_to_content = () ->
	send_to = new Object()
	field_array = new Array()
	decision_array = new Array()
	$('#fields p').each( (index,value) ->
		field_array.push(JSON.parse($(this).text()))
		)
	$('#decisions p').each( (index,value) ->
		decision_array.push(JSON.parse($(this).text()))
		)
	send_to.Fields = field_array
	send_to.Decisions = decision_array
	step_content_html = $('#step_content')
	string_cont = JSON.stringify(send_to)
	step_content_html.val(string_cont)
