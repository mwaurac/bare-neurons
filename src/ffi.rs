unsafe extern "C" {
    pub unsafe fn relu_forward(z: *const f32, a: *mut f32, n: i64);

    pub unsafe fn relu_backward(grad_in: *const f32, z: *const f32, grad_out: *mut f32, n: i64);
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn relu_forward_works() {
        let z = [-3.0f32, -1.5, 0.0, 2.0, 5.5, -7.0, 8.0, 1.0, -9.0];
        let mut a = [0.0f32; 9];

        unsafe {
            relu_forward(z.as_ptr(), a.as_mut_ptr(), z.len() as i64);
        }

        let expected = [0.0f32, 0.0, 0.0, 2.0, 5.5, 0.0, 8.0, 1.0, 0.0];

        assert_eq!(a, expected);
    }

    #[test]
    fn relu_backward_works() {
        let z = [-3.0f32, -1.5, 0.0, 2.0, 5.5, -7.0, 8.0, 1.0, -9.0];
        let grad_in = [1.0f32, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0];
        let expected = [0.0f32, 0.0, 0.0, 4.0, 5.0, 0.0, 7.0, 8.0, 0.0];
        let mut grad_out = [0.0f32; 9];

        unsafe {
            relu_backward(
                grad_in.as_ptr(),
                z.as_ptr(),
                grad_out.as_mut_ptr(),
                z.len() as i64,
            );
        }

        assert_eq!(grad_out, expected);
    }
}
