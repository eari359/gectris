var animated_list_ = Dictionary()
var destroy_list_ = Dictionary()

func isAnimated(var node) -> bool:
	return node in animated_list_

func stopAnimation(var node):
	assert(node != null)
	if animated_list_.has(node):
		animated_list_.erase(node)

func destroy(var node):
	assert(node != null)
	destroy_list_[node] = 0.15

func setTranslation(var node, var v, amt = 10.0):
	assert(node != null)
	var diff = (v - node.translation)*20/3
	animated_list_[node] = [diff, amt]

func translate(var node, var v, var amt = 10.0):
	assert(node != null)
	if animated_list_.has(node):
		animated_list_[node][0] += v
		animated_list_[node][1] = amt
	else:
		animated_list_[node] = [v, amt]

const SCALE_AMT = 0.9
func update(var delta):
	var amt = delta * 10
	for node in animated_list_.keys():
		var node_vec = animated_list_[node]
		if node_vec is Array:
			amt = delta * node_vec[1]
			node_vec = node_vec[0]
		if node_vec.length() > 0.01:
			node.translate(node_vec * amt)
			animated_list_[node][0] -= node_vec * amt
		else:
			node.translate(node_vec)
			animated_list_.erase(node)
	
	for node in destroy_list_.keys():
		var s = destroy_list_[node]
		if s > 0.01:
			node.scale = Vector3(s * SCALE_AMT, s * SCALE_AMT, s * SCALE_AMT)
			destroy_list_[node] = s * SCALE_AMT
		else:
			destroy_list_.erase(node)
			if (animated_list_.has(node)):
				animated_list_.erase(node)
			node.queue_free()
