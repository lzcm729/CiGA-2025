shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
//// 控制参数
//uniform float health_ratio : hint_range(0.0, 1.0) = 0.2;
//uniform vec4 edge_color : source_color = vec4(0.8, 0.1, 0.1, 0.7);
//uniform float edge_width : hint_range(0.0, 1.0) = 0.25;
//uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;
//uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.3;
//
// 噪声纹理用于更自然的闪动
uniform sampler2D noise_texture : hint_default_white;
//
//void fragment() {
    //// 基础颜色
    //vec4 original_color = texture(screen_texture, UV);
    //
    //// 计算边缘距离因子
    //vec2 edge_dist = min(UV, 1.0 - UV);
	//float edge_factor = smoothstep(edge_width, 0.0, min(edge_dist.x, edge_dist.y));
    //
    //// 健康状态影响
    //float health_effect = 1.0 - health_ratio;
    //float visible_edge = edge_factor * health_effect;
    //
    //// 时间闪动效果
    //float time_pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    //float dynamic_intensity = pulse_intensity * time_pulse * health_effect;
    //
    //// 添加噪声扰动
    //float noise = texture(noise_texture, UV * 2.0 + vec2(TIME * 0.5)).r * 0.2;
    //
    //// 最终边缘效果
    //vec4 edge_effect = edge_color * visible_edge * (dynamic_intensity + 0.7 + noise);
    //
    //// 混合颜色
	//float alpha = dynamic_intensity * edge_effect.a;
    //vec4 final_color = mix(original_color, edge_effect, alpha);
    //
    //// 低血量时整体色调变化
    //if (health_ratio < 0.3) {
        //float emergency_effect = (0.3 - health_ratio) / 0.3;
        //float color_shift = sin(TIME * 3.0) * 0.1 * emergency_effect;
        //final_color.r += color_shift;
        //final_color.gb -= color_shift * 0.5;
    //}
    //
    //COLOR = final_color;
//}

// 控制参数
uniform vec4 glow_color : source_color = vec4(0.2, 0.6, 1.0, 0.5); // 呼吸灯颜色
uniform float use_breath : hint_range(0.0, 1.0) = 1.0;
uniform float speed : hint_range(0.1, 10.0) = 1.0; // 呼吸速度
uniform float width : hint_range(0.0, 1.0) = 0.1; // 边缘宽度
uniform float intensity : hint_range(0.0, 2.0) = 1.0; // 最大强度
uniform float ratio : hint_range(0.0, 1.0) = 1.0;
void fragment() {
    // 计算到边缘的距离 (0-0.5)
    vec2 edge_dist = min(UV, 1.0 - UV);
    float edge_factor = smoothstep(width * ratio, 0.0, min(edge_dist.x, edge_dist.y));
    
    // 呼吸效果 (0-1循环)
    float breath = (use_breath > 0.f) ? (sin(TIME * speed) + 1.0) / 2.0 : 1.0;
    float noise = (texture(noise_texture, UV).r > 0.4) ? 1.f : 0.f;
    // 组合效果
    float glow_strength = edge_factor * breath * intensity * noise;
    vec4 glow = glow_color * glow_strength;
    
    // 混合原始颜色
    vec4 original = texture(screen_texture, UV);
    COLOR = mix(original, glow, glow.a);
}